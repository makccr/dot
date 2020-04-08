" Plugins (VimPlug)
call plug#begin()  
    "functionality
    Plug 'airblade/vim-gitgutter' 
    Plug 'junegunn/goyo.vim'
    Plug 'junegunn/limelight.vim' 
    Plug 'vifm/vifm.vim'

    "Syntax
    Plug 'tpope/vim-markdown'
    Plug 'ap/vim-css-color'
    Plug 'vim-scripts/fountain.vim'

    "Color schemes 
    Plug 'morhetz/gruvbox'
    Plug 'kristijanhusak/vim-hybrid-material'
    Plug 'NLKNguyen/papercolor-theme'
    Plug 'jacoborus/tender.vim'
    Plug 'romainl/Apprentice'
    Plug 'nanotech/jellybeans.vim'
    Plug 'ajh17/Spacegray.vim'
call plug#end() 
 
" General Settings
set encoding=UTF-8              "Stuff that should have been on by default
filetype plugin indent on
syntax on
set autoread
set wildmenu
set spell                       "Setting up spelling language. 
set spelllang=en_us
set backspace=indent,eol,start  "Easy of access: backspace
set noruler                     "Setting up rulers, spacing & tabs.
set confirm
set shiftwidth=4
set autoindent
set smartindent
set tabstop=4
set softtabstop=4
set expandtab  
set hls is                      "Setting up highlight for search
set ic
set cmdheight=1                 "Guides & command height
set cursorline
set number relativenumber
set nu rnu

" Status Bar
function! GitBranch()
  return system("git rev-parse --abbrev-ref HEAD 2>/dev/null | tr -d '\n'")
endfunction

function! StatuslineGit()
  let l:branchname = GitBranch()
  return strlen(l:branchname) > 0?'  '.l:branchname.' ':''
endfunction

set statusline=
set statusline+=%#PmenuSel#
set statusline+=%{StatuslineGit()}
set statusline+=%#LineNr#
set statusline+=\ %f
set statusline+=%m\
set statusline+=%=
set statusline+=%#CursorColumn#
set statusline+=\ %y
set statusline+=\ %{&fileencoding?&fileencoding:&encoding}
set statusline+=\[%{&fileformat}\]
set statusline+=\ %p%%
set statusline+=\ %l:%c

" Syntax Mappings
au BufRead,BufNewFile *.fountain set filetype=fountain

" Goyo Customization
function! s:goyo_enter()
  set noshowmode
  set noshowcmd
  set nocursorline
  Limelight
endfunction

function! s:goyo_leave()
  set showmode
  set showcmd
  set cursorline
  Limelight!
endfunction

autocmd! User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave nested call <SID>goyo_leave()

" Color Settings
colorscheme gruvbox
set background=dark

hi! Normal ctermbg=NONE guibg=NONE 
hi! NonText ctermbg=NONE guibg=NONE guifg=NONE ctermfg=NONE 
"Making background transparent in Alacritty by default

let g:limelight_conceal_ctermfg = 240
let g:limelight_default_coefficient = 0.7
let g:limelight_paragraph_span = 0

" Key Remapping
nmap <Space> :w <bar> EditVifm .<CR>
nmap <ENTER> :Goyo<CR>
map <C-s> :source ~/.config/nvim/init.vim<CR>
map <C-d> :set spelllang=de_de<CR>
map <C-l> :set background=light <CR>

nnoremap <Up> :resize +2<CR> 
nnoremap <Down> :resize -2<CR>
nnoremap <Left> :vertical resize +2<CR>
nnoremap <Right> :vertical resize -2<CR>

xnoremap K :move '<-2<CR>gv-gv
xnoremap J :move '>+1<CR>gv-gv

nnoremap Q <nop>

nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

map <F1> :colorscheme gruvbox<CR>
map <F2> :colorscheme PaperColor<CR>
map <F3> :colorscheme apprentice<CR>
map <F4> :colorscheme hybrid_material<CR>
map <F5> :colorscheme hybrid_reverse<CR>
map <F6> :colorscheme jellybeans<CR>
map <F7> :colorscheme spacegray<CR>
map <F8> :colorscheme tender<CR>

" ||\\ //|| 
" || \// || Mackenzie Criswell
" || //\ || https://makc.co
" ||   \\|| https://github.com/makccr
