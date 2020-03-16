# ![Logo](https://cloud.githubusercontent.com/assets/378023/18806594/927cb104-826c-11e6-8e4b-7b54be52108e.png)

[![macOS Build Status](https://travis-ci.org/atom/etch.svg?branch=master)](https://travis-ci.org/atom/etch)
[![Windows Build Status](https://ci.appveyor.com/api/projects/status/8lhn71sa3f6vuaqw/branch/master?svg=true)](https://ci.appveyor.com/project/Atom/etch/branch/master)
[![Dependency Status](https://david-dm.org/atom/etch.svg)](https://david-dm.org/atom/etch)

Etch is a library for writing HTML-based user interface components that provides the convenience of a **virtual DOM**, while at the same time striving to be **minimal**, **interoperable**, and **explicit**. Etch can be used anywhere, but it was specifically designed with **Atom packages** and **Electron applications** in mind.

### Overview

Etch components are ordinary JavaScript objects that conform to a minimal interface. Instead of inheriting from a superclass or building your component with a factory method, you access Etch's functionality by passing your component to Etch's library functions at specific points of your component's lifecycle. A typical component is structured as follows:

```js
/** @jsx etch.dom */

const etch = require('etch')

class MyComponent {
  // Required: Define an ordinary constructor to initialize your component.
  constructor (props, children) {
    // perform custom initialization here...
    // then call `etch.initialize`:
    etch.initialize(this)
  }

  // Required: The `render` method returns a virtual DOM tree representing the
  // current state of the component. Etch will call `render` to build and update
  // the component's associated DOM element. Babel is instructed to call the
  // `etch.dom` helper in compiled JSX expressions by the `@jsx` pragma above.
  render () {
    return <div></div>
  }

  // Required: Update the component with new properties and children.
  update (props, children) {
    // perform custom update logic here...
    // then call `etch.update`, which is async and returns a promise
    return etch.update(this)
  }

  // Optional: Destroy the component. Async/await syntax is pretty but optional.
  async destroy () {
    // call etch.destroy to remove the element and destroy child components
    await etch.destroy(this)
    // then perform custom teardown logic here...
  }
}
```

The component defined above could be used as follows:

```js
// build a component instance in a standard way...
let component = new MyComponent({foo: 1, bar: 2})

// use the component's associated DOM element however you wish...
document.body.appendChild(component.element)

// update the component as needed...
await component.update({bar: 2})

// destroy the component when done...
await component.destroy()
```

Note that using an Etch component does not require a reference to the Etch library. Etch is an implementation detail, and from the outside the component is just an ordinary object with a simple interface and an `.element` property. You can also take a more declarative approach by embedding Etch components directly within other Etch components, which we'll cover later in this document.

### Etch Lifecycle Functions

Use Etch's three lifecycle functions to associate a component with a DOM element, update that component's DOM element when the component's state changes, and tear down the component when it is no longer needed.

#### `etch.initialize(component)`

This function associates a component object with a DOM element. Its only requirement is that the object you pass to it has a `render` method that returns a virtual DOM tree constructed with the `etch.dom` helper ([Babel][babel] can be configured to compile JSX expressions to `etch.dom` calls). This function calls `render` and uses the result to build a DOM element, which it assigns to the `.element` property on your component object. `etch.initialize` also assigns any references (discussed later) to a `.refs` object on your component.

This function is typically called at the end of your component's constructor:

```js
/** @jsx etch.dom */

const etch = require('etch')

class MyComponent {
  constructor (properties) {
    this.properties = properties
    etch.initialize(this)
  }

  render () {
    return <div>{this.properties.greeting} World!</div>
  }
}

let component = new MyComponent({greeting: 'Hello'})
console.log(component.element.outerHTML) // ==> <div>Hello World!</div>
```

#### `etch.update(component[, replaceNode])`

This function takes a component that is already associated with an `.element` property and updates the component's DOM element based on the current return value of the component's `render` method. If the return value of `render` specifies that the DOM element type has changed since the last `render`, Etch will switch out the previous DOM node for the new one unless `replaceNode` is `false`.

`etch.update` is asynchronous, batching multiple DOM updates together in a single animation frame for efficiency. Even if it is called repeatedly with the same component in a given event-loop tick, it will only perform a single DOM update per component on the next animation frame. That means it is safe to call `etch.update` whenever your component's state changes, even if you're doing so redundantly. This function returns a promise that resolves when the DOM update has completed.

`etch.update` should be called whenever your component's state changes in a way that affects the results of `render`. For a basic component, you can implement an `update` method that updates your component's state and then requests a DOM update via `etch.update`. Expanding on the example from the previous section:

```js
/** @jsx etch.dom */

const etch = require('etch')

class MyComponent {
  constructor (properties) {
    this.properties = properties
    etch.initialize(this)
  }

  render () {
    return <div>{this.properties.greeting} World!</div>
  }

  update (newProperties) {
    if (this.properties.greeting !== newProperties.greeting) {
      this.properties.greeting = newProperties.greeting
      return etch.update(this)
    } else {
      return Promise.resolve()
    }
  }
}

// in an async function...

let component = new MyComponent({greeting: 'Hello'})
console.log(component.element.outerHTML) // ==> <div>Hello World!</div>
await component.update({greeting: 'Salutations'})
console.log(component.element.outerHTML) // ==> <div>Salutations World!</div>
```

There is also a synchronous variant, `etch.updateSync`, which performs the DOM update immediately. It doesn't skip redundant updates or batch together with other component updates, so you shouldn't really use it unless you have a clear reason.

##### Update Hooks

If you need to perform imperative DOM interactions in addition to the declarative updates provided by etch, you can integrate your imperative code via update hooks on the component. To ensure good performance, it's important that you segregate DOM reads and writes in the appropriate hook.

* `writeAfterUpdate` If you need to *write* to any part of the document as a result of updating your component, you should perform these writes in an optional `writeAfterUpdate` method defined on your component. Be warned: If you read from the DOM inside this method, it could potentially lead to layout thrashing by interleaving your reads with DOM writes associated with other components.

* `readAfterUpdate` If you need to *read* any part of the document as a result of updating your component, you should perform these reads in an optional `readAfterUpdate` method defined on your component. You should avoid writing to the DOM in these methods, because writes could interleave with reads performed in `readAfterUpdate` hooks defined on other components. If you need to update the DOM as a result of your reads, store state on your component and request an additional update via `etch.update`.

These hooks exist to support DOM reads and writes in response to Etch updating your component's element. If you want your hook to run code based on changes to the component's *logical* state, you can make those calls directly or via other mechanisms. For example, if you simply want to call an external API when a property on your component changes, you should move that logic into the `update` method.

#### `etch.destroy(component[, removeNode])`

When you no longer need a component, pass it to `etch.destroy`. This function will call `destroy` on any child components (child components are covered later in this document), and will additionally remove the component's DOM element from the document unless `removeNode` is `false`. `etch.destroy` is also asynchronous so that it can combine the removal of DOM elements with other DOM updates, and it returns a promise that resolves when the component destruction process has completed.

`etch.destroy` is typically called in an async `destroy` method on the component:

```js
class MyComponent {
  // other methods omitted for brevity...

  async destroy () {
    await etch.destroy(this)

    // perform component teardown... here we just log for example purposes
    let greeting = this.properties.greeting
    console.log(`Destroyed component with greeting ${greeting}`)
  }
}

// in an async function...

let component = new MyComponent({greeting: 'Hello'})
document.body.appendChild(component.element)
assert(component.element.parentElement)
await component.destroy()
assert(!component.element.parentElement)
```

### Component Composition

#### Nesting Etch Components Within Other Etch Components

Components can be nested within other components by referencing a child component's constructor in the parent component's `render` method, as follows:

```js
/** @jsx etch.dom */

const etch = require('etch')

class ChildComponent {
  constructor () {
    etch.initialize(this)
  }

  render () {
    return <h2>I am a child</h2>
  }
}

class ParentComponent {
  constructor () {
    etch.initialize(this)
  }

  render () {
    <div>
      <h1>I am a parent</div>
      <ChildComponent />
    </div>
  }
}
```

A constructor function can always take the place of a tag name in any Etch JSX expression. If the JSX expression has properties or children, these will be passed to the constructor function as the first and second argument, respectively.

```js
/** @jsx etch.dom */

const etch = require('etch')

class ChildComponent {
  constructor (properties, children) {
    this.properties = properties
    this.children = children
    etch.initialize(this)
  }

  render () {
    return (
      <div>
        <h2>I am a {this.properties.adjective} child</h2>
        <h2>And these are *my* children:</h2>
        {this.children}
      </div>
    )
  }
}

class ParentComponent {
  constructor () {
    etch.initialize(this)
  }

  render () {
    <div>
      <h1>I am a parent</div>
      <ChildComponent adjective='good'>
        <div>Grandchild 1</div>
        <div>Grandchild 2</div>
      <ChildComponent/>
    </div>
  }
}
```

If the properties or children change during an update of the parent component, Etch calls `update` on the child component with the new values. Finally, if an update causes the child component to no longer appear in the DOM or the parent component itself is destroyed, Etch will call `destroy` on the child component if it is implemented.

#### Nesting Non-Etch Components Within Etch Components

Nothing about the component composition rules requires that the child component be implemented with Etch. So long as your constructor builds an object with an `.element` property and an `update` method, it can be nested within an Etch virtual DOM tree. Your component can also implement `destroy` if you want to perform teardown logic when it is removed from the parent component.

This feature makes it easy to mix components written in different versions of Etch or wrap components written in other technologies for integration into an Etch component. You can even just use raw DOM APIs for simple or performance-critical components and use them straightforwardly within Etch.

### Keys

To keep DOM update times linear in the size of the virtual tree, Etch applies a very simple strategy when updating lists of elements. By default, if a child at a given location has the same tag name in both the previous and current virtual DOM tree, Etch proceeds to apply updates for the entire subtree.

If your virtual DOM contains a list into which you are inserting and removing elements frequently, you can associate each element in the list with a unique `key` property to identify it. This improves performance by allowing Etch to determine whether a given element tree should be *inserted* as a new DOM node, or whether it corresponds to a node that already exists that needs to be *updated*.

### References

Etch interprets any `ref` property on a virtual DOM element as an instruction to wire a reference to the underlying DOM element or child component. These references are collected in a `refs` object that Etch assigns on your component.

```js
class ParentComponent {
  constructor () {
    etch.initialize(this)
  }

  render () {
    <div>
      <span ref='greetingSpan'>Hello</span>
      <ChildComponent ref='childComponent' />
    </div>
  }
}

let component = new ParentComponent()
component.refs.greetingSpan // This is a span DOM node
component.refs.childComponent // This is a ChildComponent instance
```
Note that `ref` properties on normal HTML elements create references to raw DOM nodes, while `ref` properties on child components create references to the constructed component object, which makes its DOM node available via its `element` property.

### Handling Events

Etch supports listening to arbitrary events on DOM nodes via the special `on` property, which can be used to assign a hash of `eventName: listenerFunction` pairs:

```js
class ComponentWithEvents {
  constructor () {
    etch.initialize(this)
  }

  render () {
    return <div on={{click: this.didClick, focus: this.didFocus}} />
  }

  didClick (event) {
    console.log(event) // ==> MouseEvent {...}
    console.log(this) // ==> ComponentWithEvents {...}
  }

  didFocus (event) {
    console.log(event) // ==> FocusEvent {...}
    console.log(this) // ==> ComponentWithEvents {...}
  }
}
```

As you can see, the listener function's `this` value is automatically bound to the parent component. You should rely on this auto-binding facility rather than using arrow functions or `Function.bind` to avoid complexity and extraneous closure allocations.

### Assigning DOM Attributes

With the exception of SVG elements, Etch assigns *properties* on DOM nodes rather than HTML attributes. If you want to bypass this behavior and assign attributes instead, use the special `attributes` property with a nested object. For example, `a` and `b` below will yield the equivalent DOM node.

```js
const a = <div className='foo' />
const b = <div attributes={{class: 'foo'}}
```

This can be useful for custom attributes that don't map to DOM node properties.

### Organizing Component State

To keep the API surface area minimal, Etch is deliberately focused only on updating the DOM, leaving management of component state to component authors.

#### Controlled Components

If your component's HTML is based solely on properties passed in from the outside, you just need to implement a simple `update` method.

```js
class ControlledComponent {
  constructor (props) {
    this.props = props
    etch.initialize(this)
  }

  render () {
    // read from this.props here
  }

  update (props) {
    // you could avoid redundant updates by comparing this.props with props...
    this.props = props
    return etch.update(this)
  }
}
```

Compared to React, control is inverted. Instead of implementing `shouldComponentUpdate` to control whether or not the framework updates your element, you always explicitly call `etch.update` when an update is needed.

#### Stateful Components

If your `render` method's output is based on state managed within the component itself, call `etch.update` whenever this state is updated. You could store all state in a sub-object called `state` like React does, or you could just use instance variables.

```js
class StatefulComponent {
  constructor () {
    this.counter = 0
    etch.initialize(this)
  }

  render () {
    <div>
      <span>{this.counter}</span>
      <button onclick={() => this.incrementCounter()}>
        Increment Counter
      </button>
    </div>
  }

  incrementCounter () {
    this.counter++
    // since we updated state we use in render, call etch.update
    return etch.update(this)
  }
}
```

#### What About A Component Superclass?

To keep this library small and explicit, we're favoring composition over inheritance. Etch gives you a small set of tools for updating the DOM, and with these you can accomplish your objectives with some simple patterns. You *could* write a simple component superclass in your application to remove a bit of boilerplate, or even publish one on npm. For now, however, we're going to avoid taking on the complexity of such a superclass into this library. We may change our mind in the future.

### Customizing The Scheduler

Etch exports a `setScheduler` method that allows you to override the scheduler it uses to coordinate DOM writes. When using Etch inside a larger application, it may be important to coordinate Etch's DOM interactions with other libraries to avoid synchronous reflows.

For example, when using Etch in Atom, you should set the scheduler as follows:

```js
etch.setScheduler(atom.views)
```

Read comments in the [scheduler assignment][scheduler-assignment] and [default scheduler][default-scheduler] source code for more information on implementing your own scheduler.

### Performance

The [github.com/krausest/js-framework-benchmark](https://github.com/krausest/js-framework-benchmark) runs various benchmarks using different frameworks. It should give you an idea how etch performs compared to other frameworks.

Checkout the benchmarks [here](https://rawgit.com/krausest/js-framework-benchmark/master/webdriver-ts-results/table.html).

### Feature Requests

Etch aims to stay small and focused. If you have a feature idea, consider implementing it as a library that either wraps Etch or, even better, that can be used in concert with it. If it's impossible to implement your feature outside of Etch, we can discuss adding a hook that makes your feature possible.

[babel]: https://babeljs.io/
[scheduler-assignment]: https://github.com/nathansobo/etch/blob/master/lib/scheduler-assignment.js
[default-scheduler]: https://github.com/nathansobo/etch/blob/master/lib/default-scheduler.js
[dom-listener]: https://github.com/atom/dom-listener
