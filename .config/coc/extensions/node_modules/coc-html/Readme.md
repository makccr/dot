# coc-html

Html language server extension for [coc.nvim](https://github.com/neoclide/coc.nvim).

Code changed from html extension of [VSCode](https://github.com/Microsoft/vscode/tree/master/extensions/html-language-features)

## Install

In your vim/neovim, run command:

```
:CocInstall coc-html
```

## Features

- Completion provider
- Formatting
- Document Symbols & Highlights
- Document Links
- CSS mode
- Javascript mode

## Configuration options

- `html.enable` set to `false` to disable html language server.
- `html.trace.server` set trace level of LSP traffic.
- `html.execArgv` add `execArgv` to `child_process.spawn`
- `html.filetypes` default `[ "html", "handlebars", "htmldjango" ]`.
- `html.format.enable` enable format support.
- `html.validate.scripts` validate for embedded scripts.
- `html.validate.styles` validate for embedded styles.
- `html.autoClosingTags` Enable/disable autoClosing of HTML tags.

Trigger completion in `coc-settings.json` for complete list.

## License

MIT
