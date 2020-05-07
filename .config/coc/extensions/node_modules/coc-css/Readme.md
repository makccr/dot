# coc-css

Css language server extension for [coc.nvim](https://github.com/neoclide/coc.nvim).

Uses [vscode-css-languageservice](https://github.com/Microsoft/vscode-css-languageservice) inside.

## Install

In your vim/neovim, run the command:

```
:CocInstall coc-css
```

## Features

Coc has support for all features that [vscode-css-languageservice](https://www.npmjs.com/package/vscode-css-languageservice) has.

- `doValidation` analyzes an input string and returns syntax and lint errros.
- `doComplete` provides completion proposals for a given location.
- `doHover` provides a hover text for a given location.
- `findDefinition` finds the definition of the symbol at the given location.
- `findReferences` finds all references to the symbol at the given location.
- `findDocumentHighlights` finds all symbols connected to the given location.
- `findDocumentSymbols` provides all symbols in the given document
- `doCodeActions` evaluates code actions for the given location, typically to fix a problem.
- `findColorSymbols` evaluates all color symbols in the given document
- `doRename` renames all symbols connected to the given location.
- `getFoldingRanges` returns folding ranges in the given document.

## Configuration options

- `css.trace.server` trace LSP traffic in output channel.
- `css.execArgv` add `execArgv` to `child_process.spawn`
- `css.validate` enables validation for css files, default `true`.
- `css.lint.[rulename]` set rule for css lint, to get list of rules, trigger
  completion in your `css-settings.json`
- `less.validate` `less.lint.[rulename]` same as css, but for less.
- `wxss.validate` `wxss.lint.[rulename]` same as css, but for wxss.
- `scss.validate` `scss.lint.[rulename]` same as css, but for scss.

## License

MIT
