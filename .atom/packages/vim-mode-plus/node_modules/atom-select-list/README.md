# atom-select-list

This module is an [etch component](https://github.com/atom/etch) that can be used in Atom packages to show a select list with fuzzy filtering, keyboard/mouse navigation and other cool features.

## Installation

```bash
npm install --save atom-select-list
```

## Usage

After installing the module, you can simply require it and use it as a standalone component:

```js
const SelectList = require('atom-select-list')

const usersSelectList = new SelectList({
  items: ['Alice', 'Bob', 'Carol']
})
document.body.appendChild(usersSelectList.element)
```

Or within another etch component:

```jsx
render () {
  return (
    <SelectList items={this.items} />
  )
}
```

## API

When creating a new instance of a select list, or when calling `update` on an existing one, you can supply a JavaScript object that can contain any of the following properties:

* `items: [Object]`: an array containing the objects you want to show in the select list.
* `elementForItem: (item: Object, options: Object) -> HTMLElement`: a function that is called whenever an item needs to be displayed.
  * `options: Object`:
    * `selected: Boolean`: indicating whether item is selected or not.
    * `index: Number`: item's index.
    * `visible: Boolean`: indicating whether item is visible in viewport or not. Unless `initiallyVisibleItemCount` was given, this value is always `true`.
* (Optional) `maxResults: Number`: the number of maximum items that are shown.
* (Optional) `filter: (items: [Object], query: String) -> [Object]`: a function that allows to decide which items to show whenever the query changes. By default, it uses [fuzzaldrin](https://github.com/atom/fuzzaldrin) to filter results.
* (Optional) `filterKeyForItem: (item: Object) -> String`: when `filter` is not provided, this function will be called to retrieve a string property on each item and that will be used to filter them.
* (Optional) `filterQuery: (query: String) -> String`: a function that allows to apply a transformation to the user query and whose return value will be used to filter items.
* (Optional) `query: String`: a string that will replace the contents of the query editor.
* (Optional) `selectQuery: Boolean`: a boolean indicating whether the query text should be selected or not.
* (Optional) `order: (item1: Object, item2: Object) -> Number`: a function that allows to change the order in which items are shown.
* (Optional) `emptyMessage: String`: a string shown when the list is empty.
* (Optional) `errorMessage: String`: a string that needs to be set when you want to notify the user that an error occurred.
* (Optional) `infoMessage: String`: a string that needs to be set when you want to provide some information to the user.
* (Optional) `loadingMessage: String`: a string that needs to be set when you are loading items in the background.
* (Optional) `loadingBadge: String/Number`: a string or number that needs to be set when the progress status changes (e.g. a percentage showing how many items have been loaded so far).
* (Optional) `itemsClassList: [String]`: an array of strings that will be added as class names to the items element.
* (Optional) `initialSelectionIndex: Number`: the index of the item to initially select and automatically select after query changes; defaults to `0`.
* (Optional) `didChangeQuery: (query: String) -> Void`: a function that is called when the query changes.
* (Optional) `didChangeSelection: (item: Object) -> Void`: a function that is called when the selected item changes.
* (Optional) `didConfirmSelection: (item: Object) -> Void`: a function that is called when the user clicks or presses <kbd>Enter</kbd> on an item.
* (Optional) `didConfirmEmptySelection: () -> Void`: a function that is called when the user presses <kbd>Enter</kbd> but the list is empty.
* (Optional) `didCancelSelection: () -> Void`: a function that is called when the user presses <kbd>Esc</kbd> or the list loses focus.
* (Optional) `initiallyVisibleItemCount: Number`: When this options was provided, `SelectList` observe visibility of items in viewport, visibility state is passed as `visible` option to `elementForItem`. This is mainly used to skip heavy computation for invisible items.
