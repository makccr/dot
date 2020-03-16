const render = require('./render')
const updateProps = require('./update-props')

function patch (oldVirtualNode, newVirtualNode, options) {
  const oldNode = oldVirtualNode.domNode

  if (newVirtualNode === oldVirtualNode) return oldNode

  if (virtualNodesAreEqual(oldVirtualNode, newVirtualNode)) {
    let newNode
    if (newVirtualNode.text != null) {
      oldNode.nodeValue = newVirtualNode.text
      newNode = oldNode
    } else {
      if (typeof newVirtualNode.tag === 'function') {
        newNode = updateComponent(oldVirtualNode, newVirtualNode, options)
      } else {
        updateChildren(oldNode, oldVirtualNode.children, newVirtualNode.children, options)
        updateProps(oldNode, oldVirtualNode, newVirtualNode, options)
        newNode = oldNode
      }
    }
    newVirtualNode.domNode = newNode
    if (newNode !== oldNode && oldNode.parentNode) {
      oldNode.parentNode.replaceChild(newNode, oldNode)
    }
    return newNode
  } else {
    const parentNode = oldNode.parentNode
    const nextSibling = oldNode.nextSibling
    removeVirtualNode(oldVirtualNode, options && options.refs)
    const newNode = render(newVirtualNode, options)
    if (parentNode) parentNode.insertBefore(newNode, nextSibling)
    newVirtualNode.domNode = newNode
    return newNode
  }
}

function updateComponent (oldVirtualNode, newVirtualNode, options) {
  const {component, props: oldProps} = oldVirtualNode
  let {props: newProps, children: newChildren} = newVirtualNode
  newVirtualNode.component = component
  if (options && options.refs) {
    const refs = options.refs
    const oldRefName = oldProps && oldProps.ref
    const newRefName = newProps && newProps.ref
    if (newRefName !== oldRefName) {
      if (oldRefName && refs[oldRefName] === component) delete refs[oldRefName]
      if (newRefName) refs[newRefName] = component
    }
  }
  component.update(newProps || {}, newChildren)
  return component.element
}

let mapPool = [new Map(), new Map(), new Map(), new Map()]

function updateChildren (parentElement, oldChildren, newChildren, options) {
  var oldStartIndex = 0
  var oldEndIndex = oldChildren.length - 1
  var oldStartChild = oldChildren[0]
  var oldEndChild = oldChildren[oldEndIndex]

  var newStartIndex = 0
  var newEndIndex = newChildren.length - 1
  var newStartChild = newChildren[0]
  var newEndChild = newChildren[newEndIndex]

  var oldIndicesByKey

  while (oldStartIndex <= oldEndIndex && newStartIndex <= newEndIndex) {
    if (!oldStartChild) {
      oldStartChild = oldChildren[++oldStartIndex]
    } else if (!oldEndChild) {
      oldEndChild = oldChildren[--oldEndIndex]
    } else if (virtualNodesAreEqual(oldStartChild, newStartChild)) {
      patch(oldStartChild, newStartChild, options)
      oldStartChild = oldChildren[++oldStartIndex]
      newStartChild = newChildren[++newStartIndex]
    } else if (virtualNodesAreEqual(oldEndChild, newEndChild)) {
      patch(oldEndChild, newEndChild, options)
      oldEndChild = oldChildren[--oldEndIndex]
      newEndChild = newChildren[--newEndIndex]
    } else if (virtualNodesAreEqual(oldStartChild, newEndChild)) {
      patch(oldStartChild, newEndChild, options)
      parentElement.insertBefore(oldStartChild.domNode, oldEndChild.domNode.nextSibling)
      oldStartChild = oldChildren[++oldStartIndex]
      newEndChild = newChildren[--newEndIndex]
    } else if (virtualNodesAreEqual(oldEndChild, newStartChild)) {
      patch(oldEndChild, newStartChild, options)
      parentElement.insertBefore(oldEndChild.domNode, oldStartChild.domNode);
      oldEndChild = oldChildren[--oldEndIndex]
      newStartChild = newChildren[++newStartIndex]
    } else {
      if (!oldIndicesByKey) {
        if (mapPool.length > 0) {
          oldIndicesByKey = mapPool.pop()
          oldIndicesByKey.clear()
        } else {
          oldIndicesByKey = new Map()
        }
        mapOldKeysToIndices(oldIndicesByKey, oldChildren, oldStartIndex, oldEndIndex)
      }

      var key = getKey(newStartChild)
      var oldIndex = key ? oldIndicesByKey.get(key) : null
      if (oldIndex == null) {
        parentElement.insertBefore(render(newStartChild, options), oldStartChild.domNode)
        newStartChild = newChildren[++newStartIndex]
      } else {
        var oldChildToMove = oldChildren[oldIndex]
        patch(oldChildToMove, newStartChild, options)
        oldChildren[oldIndex] = undefined
        parentElement.insertBefore(oldChildToMove.domNode, oldStartChild.domNode)
        newStartChild = newChildren[++newStartIndex]
      }
    }
  }

  if (oldStartIndex > oldEndIndex) {
    var subsequentElement = newChildren[newEndIndex + 1] ? newChildren[newEndIndex + 1].domNode : null
    for (let i = newStartIndex; i <= newEndIndex; i++) {
      parentElement.insertBefore(render(newChildren[i], options), subsequentElement)
    }
  } else if (newStartIndex > newEndIndex) {
    for (let i = oldStartIndex; i <= oldEndIndex; i++) {
      var child = oldChildren[i]
      if (child) removeVirtualNode(child, options && options.refs)
    }
  }

  if (oldIndicesByKey) mapPool.push(oldIndicesByKey)
}

function removeVirtualNode (virtualNode, refs, removeDOMNode = true) {
  const {domNode, props, children, component} = virtualNode
  const ref = props && props.ref
  if (component) {
    if (refs && ref && refs[ref] === component) delete refs[ref]
    if (component.destroy) component.destroy()
  } else {
    if (refs && ref && refs[ref] === domNode) delete refs[ref]
    if (children) {
      for (let i = 0; i < children.length; i++) {
        removeVirtualNode(children[i], refs, false)
      }
    }
  }

  if (removeDOMNode) domNode.remove()
}

function virtualNodesAreEqual (oldVirtualNode, newVirtualNode) {
  return (
    getKey(oldVirtualNode) === getKey(newVirtualNode)
      && oldVirtualNode.tag === newVirtualNode.tag
  )
}

function getKey (virtualNode) {
  return virtualNode.props ? virtualNode.props.key : undefined
}

function mapOldKeysToIndices (oldIndicesByKey, children, startIndex, endIndex) {
  for (let i = startIndex; i <= endIndex; i++) {
    const key = getKey(children[i])
    if (key) oldIndicesByKey.set(key, i)
  }
  return oldIndicesByKey
}

module.exports = patch
