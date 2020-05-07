# coc-pairs

Auto pair extension for [coc.nvim](https://github.com/neoclide/coc.nvim).

**Note** you can use other vim auto pairs plugins with coc.nvim, it's a
simplified implementation to make auto pairs work like in VSCode.

**Note** `b:coc_paires` have renamed to `b:coc_pairs`

For enhanced `<CR>` experience, checkout `:h coc#on_enter()`.

## Tips

- You should disable/remove other auto pair plugins for this extension work as expected.
- When you type a paired character which is just the next character, it would just move to the right by one column.
- When the previous content ends with two inserting characters, the characters would just be inserted without inserting the paired character. This makes inserting triple quotes easier.
- `'` only pairs when the character before is not a word character.
- for `<` to insert paired `>`, the previous character should not be an empty space.

## Install

In vim/neovim, run this command:

```
:CocInstall coc-pairs
```

## Features

- Insert pair characters automatically.
- Buffer local pairs, ex: `autocmd FileType tex let b:coc_pairs = [["$", "$"]]`

## Options

- `pairs.disableLanguages`, list of language ids to disable this extension, default: `[]`.
- `pairs.enableCharacters`, list of enabled characters, default: `` ["(", "[", "{", "<", "'", "\"", "`"] ``.
- `pairs.enableBackspace`, enable imap for backspace to remove paired characters,
  default: `true`, won't work when `<bs>` is already mapped.

To disable characters for a specified filetype, you can use `b:coc_pairs_disabled`, ex:

    autocmd FileType markdown let b:coc_pairs_disabled = ['`']

## License

MIT
