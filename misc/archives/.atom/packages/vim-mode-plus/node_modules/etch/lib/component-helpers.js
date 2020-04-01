const render = require('./render')
const patch = require('./patch')
const {getScheduler} = require('./scheduler-assignment')

const componentsWithPendingUpdates = new WeakSet()
let syncUpdatesInProgressCounter = 0
let syncDestructionsInProgressCounter = 0

function isValidVirtualNode (virtualNode) {
  return virtualNode != null && virtualNode !== false
}

// This function associates a component object with a DOM element by calling
// the components `render` method, assigning an `.element` property on the
// object and also returning the element.
//
// It also assigns a `virtualNode` property based on the return value of the
// `render` method. This will be used later by `performElementUpdate` to diff
// the new results of `render` with the previous results when updating the
// component's element.
//
// Finally, this function also associates the component with a `refs` object,
// which is populated with references to elements based on `ref` properties on
// nodes of the `virtual-dom` tree. Before calling into `virtual-dom` to create
// the DOM tree, it pushes this `refs` object to a shared stack so it can be
// accessed by hooks during the creation of individual elements.
function initialize(component) {
  if (typeof component.update !== 'function') {
    throw new Error('Etch components must implement `update(props, children)`.')
  }

  let virtualNode = component.render()
  if (!isValidVirtualNode(virtualNode)) {
    let namePart = component.constructor && component.constructor.name ? ' in ' + component.constructor.name : ''
    throw new Error('invalid falsy value ' + virtualNode + ' returned from render()' + namePart)
  }

  component.refs = {}
  component.virtualNode = virtualNode
  component.element = render(component.virtualNode, {
    refs: component.refs, listenerContext: component
  })
}

// This function receives a component that has already been associated with an
// element via a previous call to `initialize` and updates this element by
// calling `render` on the component.
//
// When called in normal circumstances, it uses the scheduler to defer this
// update until the next animation frame, and will only perform one update of a
// given component in a given frame. This means you can call `update`
// repeatedly in a given tick without causing redundant updates.
//
// If this function called during another synchronous update (for example, as a
// result of a call to `update` on a child component), the update is performed
// synchronously.
//
// Returns a promise that will resolve when the requested update has been
// completed.
function update (component, replaceNode=true) {
  if (syncUpdatesInProgressCounter > 0) {
    updateSync(component, replaceNode)
    return Promise.resolve()
  }

  let scheduler = getScheduler()

  if (!componentsWithPendingUpdates.has(component)) {
    componentsWithPendingUpdates.add(component)
    scheduler.updateDocument(function () {
      componentsWithPendingUpdates.delete(component)
      updateSync(component, replaceNode)
    })
  }

  return scheduler.getNextUpdatePromise()
}

// Synchronsly updates the DOM element associated with a component object. .
// This method assumes the presence of `.element` and `.virtualNode`
// properties on the component, which are assigned in the `initialize`
// function.
//
// It calls `render` on the component to obtain the desired state of the DOM,
// then `diff`s it with the previous state and `patch`es the element based on
// the resulting diff. During the patch operation, it pushes the component's
// `refs` object to a shared stack so that references to DOM elements can be
// updated.
//
// If `update` is called during the invocation of `updateSync`,
// the requests are processed synchronously as well. We track whether this is
// the case by incrementing and decrementing `syncUpdatesInProgressCounter`
// around the call.
//
// For now, etch does not allow the root tag of the `render` method to change
// between invocations, because we want to preserve a one-to-one relationship
// between component objects and DOM elements for simplicity.
function updateSync (component, replaceNode=true) {
  if (!isValidVirtualNode(component.virtualNode)) {
    throw new Error(`${component.constructor ? component.constructor.name + ' instance' : component} is not associated with a valid virtualNode. Perhaps this component was never initialized?`)
  }

  if (component.element == null) {
    throw new Error(`${component.constructor ? component.constructor.name + ' instance' : component} is not associated with a DOM element. Perhaps this component was never initialized?`)
  }

  let newVirtualNode = component.render()
  if (!isValidVirtualNode(newVirtualNode)) {
    const namePart = component.constructor && component.constructor.name ? ' in ' + component.constructor.name : ''
    throw new Error('invalid falsy value ' + newVirtualNode + ' returned from render()' + namePart)
  }

  syncUpdatesInProgressCounter++
  let oldVirtualNode = component.virtualNode
  let oldDomNode = component.element
  let newDomNode = patch(oldVirtualNode, newVirtualNode, {
    refs: component.refs,
    listenerContext: component
  })
  component.virtualNode = newVirtualNode
  if (newDomNode !== oldDomNode && !replaceNode) {
    throw new Error('The root node type changed on update, but the update was performed with the replaceNode option set to false')
  } else {
    component.element = newDomNode
  }

  // We can safely perform additional writes after a DOM update synchronously,
  // but any reads need to be deferred until all writes are completed to avoid
  // DOM thrashing. Requested reads occur at the end of the the current frame
  // if this method was invoked via the scheduler. Otherwise, if `updateSync`
  // was invoked outside of the scheduler, the default scheduler will defer
  // reads until the next animation frame.
  if (typeof component.writeAfterUpdate === 'function') {
    component.writeAfterUpdate()
  }
  if (typeof component.readAfterUpdate === 'function') {
    getScheduler().readDocument(function () {
      component.readAfterUpdate()
    })
  }

  syncUpdatesInProgressCounter--
}

// Removes the component's associated element and calls `destroy` on any child
// components. Normally, this function is asynchronous and will perform the
// destruction on the next animation frame. If called as the result of another
// update or destruction, it calls `destroy` on child components synchronously.
// If called as the result of destroying a component higher in the DOM, the
// element is not removed to avoid redundant DOM manipulation. Returns a promise
// that resolves when the destruction is completed.
function destroy (component, removeNode=true) {
  if (syncUpdatesInProgressCounter > 0 || syncDestructionsInProgressCounter > 0) {
    destroySync(component, removeNode)
    return Promise.resolve()
  }

  let scheduler = getScheduler()
  scheduler.updateDocument(function () {
    destroySync(component, removeNode)
  })
  return scheduler.getNextUpdatePromise()
}

// A synchronous version of `destroy`.
//
// Note that we track whether `destroy` calls are in progress and only remove
// the element if we are not a nested call.
function destroySync (component, removeNode=true) {
  syncDestructionsInProgressCounter++
  destroyChildComponents(component.virtualNode)
  if (syncDestructionsInProgressCounter === 1 && removeNode) component.element.remove()
  syncDestructionsInProgressCounter--
}

function destroyChildComponents(virtualNode) {
  if (virtualNode.component && typeof virtualNode.component.destroy === 'function') {
    virtualNode.component.destroy()
  } else if (virtualNode.children) {
    virtualNode.children.forEach(destroyChildComponents)
  }
}

module.exports = {
  initialize,
  update, updateSync,
  destroy, destroySync
}
