# coc-git

Git integration of [coc.nvim](https://github.com/neoclide/coc.nvim).

**Note:** many useful features not implemented, it's recommended to
use plugin like [vim-fugitive](https://github.com/tpope/vim-fugitive) at the
same time.

## Install

In your vim/neovim, run command:

```
:CocInstall coc-git
```

## Why

- Always async.
- Always refresh on TextChange.
- Powerful list support.
- Semantic commit and github issues completion support.

## Features

- Sign support for git status of current buffer.
- Git status of current project, by `g:coc_git_status`.
- Git status of current buffer, by`b:coc_git_status`.
- Git status of current line, by`b:coc_git_blame` for statusline, and `addGBlameToVirtualText` for inline blames.
- Git related lists, including `issues`, `gfiles`, `gstatus`, `commits`, `branches` & `bcommits`
- Keymaps for git chunks, including `<Plug>(coc-git-chunkinfo)` `<Plug>(coc-git-nextchunk)` & `<Plug>(coc-git-prevchunk)` ,
- Commands for chunks, including `git.chunkInfo` `git.chunkStage` `git.chunkUndo` and more.
- Completion support for semantic commit.
- Completion support for GitHub/GitLab issues.
  
**Note** for GitHub issues completion support:

- `GITHUB_API_TOKEN=xxx` needs to be set in env to fetch issues from private repositories

**Note** for GitLab issues completion support:

- current only API `v4` support, which availabled since GitLab 9.0
- `GITLAB_PRIVATE_TOKEN=XXX` needs to be set in env, check [Personal access tokens](https://docs.gitlab.com/ee/user/profile/personal_access_tokens.html)
- GitLab host needs to be set in `coc-settings.json`, for example `"git.gitlab.hosts": ["gitlab.example.com", "gitlab.com"]`

## Configuration

- `git.enableGlobalStatus`: Enable global g:coc_git_status, default: `true`.
- `git.command`: Command for git, could be absolute path of git executable, default: `"git"`.
- `git.branchCharacter`: Branch character used with g:coc_git_branch, default: `""`.
- `git.remoteName`: Remote name used for fetch github issues, default: `origin`.
- `git.enableGutters`: Enable gutters in sign column., default: `true`.
- `git.realtimeGutters`: Change to `false` when you want gutters update only on save, default: `true`.
- `git.signOffset`: Start offset of sign gutter, change to higher value to prevent overwrite by other plugin., default: `99`.
- `git.changedSign.text`: Text of changed sign., default: `"~"`.
- `git.changedSign.hlGroup`: Highlight group for changed sign., default: `"DiffChange"`.
- `git.addedSign.text`: Text of added sign., default: `"+"`.
- `git.addedSign.hlGroup`: Highlight group for added sign., default: `"DiffAdd"`.
- `git.removedSign.text`: Text of removed sign., default: `"_"`.
- `git.removedSign.hlGroup`: Highlight group for removed sign., default: `"DiffDelete"`.
- `git.topRemovedSign.text`: Text of top removed sign., default: `"‾"`.
- `git.topRemovedSign.hlGroup`: Highlight group for top removed sign., default: `"DiffDelete"`.
- `git.changeRemovedSign.text`: Text of change removed sign., default: `"≃"`.
- `git.changeRemovedSign.hlGroup`: Highlight group for change removed sign., default: `"DiffDelete"`.
- `git.splitWindowCommand`: Command used when split new window for show commit, default: `above sp`
- `git.virtualTextPrefix`: Prefix of git blame information to virtual text, require virtual text feature of neovim. default: `5 <Space>`.
- `git.addGBlameToVirtualText`: Add git blame information to virtual text, require virtual text feature of neovim. default: `false`.
- `git.addGBlameToBufferVar`: Add git blame information to b:coc_git_blame. default: `false`.
- `git.semanticCommit.filetypes`: filetype list to enable semantic commit completion, default: `["gitcommit", "gina-commit"]`
- `git.gitlab.hosts`: Custom GitLab host list, defaults: `['gitlab.com']`
- `coc.source.issues.enable`: enable issues completion from github, default `true`.
- `coc.source.issues.priority`: priority of issues source, default: `9`.
- `coc.source.issues.shortcut`: shortcut of issues source, default: `"I"`.
- `coc.source.issues.filetypes`: filetype list to enable issues source, default: `["gitcommit", "gina-commit"]`

more information, see [package.json](https://github.com/neoclide/coc-git/blob/master/package.json)

**Note** for user from [vim-gitgutter](https://github.com/airblade/vim-gitgutter),
if your have highlight groups defined for vim-gitgutter, you can use:

```json
"git.addedSign.hlGroup": "GitGutterAdd",
"git.changedSign.hlGroup": "GitGutterChange",
"git.removedSign.hlGroup": "GitGutterDelete",
"git.topRemovedSign.hlGroup": "GitGutterDelete",
"git.changeRemovedSign.hlGroup": "GitGutterChangeDelete",
```

## Usage

### Statusline integration

- `g:coc_git_status` including git branch and current project status.
- `b:coc_git_status` including changed lines of current buffer.
- `b:coc_git_blame` including blame info of current line.

Example for lightline user:

```viml
" lightline
let g:lightline = {
  \ 'active': {
  \   'left': [
  \     [ 'mode', 'paste' ],
  \     [ 'ctrlpmark', 'git', 'diagnostic', 'cocstatus', 'filename', 'method' ]
  \   ],
  \   'right':[
  \     [ 'filetype', 'fileencoding', 'lineinfo', 'percent' ],
  \     [ 'blame' ]
  \   ],
  \ },
  \ 'component_function': {
  \   'blame': 'LightlineGitBlame',
  \ }
\ }

function! LightlineGitBlame() abort
  let blame = get(b:, 'coc_git_blame', '')
  " return blame
  return winwidth(0) > 120 ? blame : ''
endfunction
```

If you're not using statusline plugin, you can add them to statusline by:

```vim
set statusline^=%{get(g:,'coc_git_status','')}%{get(b:,'coc_git_status','')}%{get(b:,'coc_git_blame','')}
```

### User autocmd

```vim
autocmd User CocGitStatusChange {command}
```

Triggered after the `g:coc_git_status` `b:coc_git_status` `b:coc_git_blame` has changed.

Could be used for update the statusline.

### Keymaps

Create keymappings like:

```vim
" navigate chunks of current buffer
nmap [g <Plug>(coc-git-prevchunk)
nmap ]g <Plug>(coc-git-nextchunk)
" show chunk diff at current position
nmap gs <Plug>(coc-git-chunkinfo)
" show commit contains current position
nmap gc <Plug>(coc-git-commit)
" create text object for git chunks
omap ig <Plug>(coc-git-chunk-inner)
xmap ig <Plug>(coc-git-chunk-inner)
omap ag <Plug>(coc-git-chunk-outer)
xmap ag <Plug>(coc-git-chunk-outer)
```

### Commands

Use command `:CocCommand` to open commands and type `git.` to get all git
related commands.

- `:CocCommand git.copyUrl` Copy url of current line to clipboard, github url supported.
- `:CocCommand git.chunkInfo` Show chunk info under cursor.
- `:CocCommand git.chunkUndo` Undo current chunk.
- `:CocCommand git.chunkStage` Stage current chunk.
- `:CocCommand git.diffCached` Show cached diff in preview window.
- `:CocCommand git.showCommit` Show commit of current chunk.
- `:CocCommand git.browserOpen` Open current line in browser, github url supported.
- `:CocCommand git.foldUnchanged` Fold unchanged lines of current buffer.
- `:CocCommand git.toggleGutters` Toggle git gutters in sign column.

### Work with git lists

To open a specified coc list, you have different ways:

- Run `:CocList` and select the list by `<CR>`.
- Run `:CocList` and type name of list for completion.
- Create keymap for open specified list with list options, like:

  ```vim
  nnoremap <silent> <space>g  :<C-u>CocList --normal gstatus<CR>
  ```

To toggle list mode, use `<C-o>` and `i`.

To move up&down on insertmode, use `<C-j>` and `<C-k>`

To run a action, press `<tab>` and select the action.

For more advance usage, checkout `:h coc-list`.

### Issue autocomplete from multiple GitHub repositories

To enable autocompletion of issues from multiple GitHub repositories, put a comma-separated list of issue repository specifiers in the git config variable `coc-git.issuesources`.
An issue repository specifier looks like this: `github/neoclide/coc-git`.

- The first part specifies the issue provider, currently only "github" is supported
- The second part specifies the organization or owner of the repository
- The third part specifies the repository name

Multiple repositories can be specified using comma separation, like this: `github/neoclide/coc-git,github/neoclide/coc.nvim`

## F.A.Q

Q: Virtual text not working.

A: Make sure your neovim support virtual text by command `:echo exists('*nvim_buf_set_virtual_text')`.

## License

MIT
