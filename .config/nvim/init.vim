" Plug-ins
call plug#begin('~/.vim/plugged')
" Tools
    Plug 'airblade/vim-gitgutter'
    Plug 'junegunn/goyo.vim'
    Plug 'vifm/vifm.vim'
    Plug 'junegunn/limelight.vim'
" Syntax
    Plug 'tpope/vim-markdown'
    Plug 'ap/vim-css-color' "Displays a preview of colors with CSS 
    Plug 'vim-scripts/fountain.vim'
" Color-schemes
    Plug 'morhetz/gruvbox' "My favorite theme
    Plug 'kristijanhusak/vim-hybrid-material'
    Plug 'NLKNguyen/papercolor-theme'
    Plug 'jacoborus/tender.vim'
    Plug 'romainl/Apprentice'
    Plug 'nanotech/jellybeans.vim'
    Plug 'ajh17/Spacegray.vim'
call plug#end() 
 
" General Settings
set encoding=UTF-8
filetype plugin indent on  "Enabling Plugin & Indent
syntax on  "Turning Syntax on
set autoread
set wildmenu
set spelllang=en_us
set spell
set backspace=indent,eol,start  "Making sure backspace works
set noruler  "Setting up rulers & spacing, tabs
set confirm
set shiftwidth=4
set autoindent
set smartindent
set tabstop=4
set softtabstop=4
set expandtab  
set hls is  "Making sure search highlights words as we type them
set ic
set laststatus=2 "Setting the size for the command area, and airline status bar
set cmdheight=1
set cursorline

" Status-line
set statusline=
set statusline+=%#IncSearch#
set statusline+=\ %M
set statusline+=\ %y
set statusline+=\ %r
set statusline+=%#CursorLineNr#
set statusline+=\ %F
set statusline+=%= "Right side settings
set statusline+=%#Search#
set statusline+=\ %c:%l/%L
set statusline+=\ %p%%
set statusline+=\ [%n]

" Some little fixes
au BufRead,BufNewFile *.fountain set filetype=fountain "Enabling fountain syntax

" Key-bindings
map <Space> :EditVifm .<CR>
map <ENTER> :Goyo<CR>
map <C-g> :set spelllang=de_de<CR>
map <C-l> :set background=light<CR>
map <C-s> :source ~/.config/nvim/init.vim<CR>

nnoremap <Up> :resize +2<CR> 
nnoremap <Down> :resize -2<CR>
nnoremap <Left> :vertical resize +2<CR>
nnoremap <Right> :vertical resize -2<CR>

xnoremap K :move '<-2<CR>gv-gv
xnoremap J :move '>+1<CR>gv-gv

nnoremap Q <nop>

nnoremap <C-h> <C-W>h
nnoremap <C-j> <C-W>j
nnoremap <C-k> <C-W>k
nnoremap <C-l> <C-W>l

map <F1> :colorscheme gruvbox<CR>
map <F2> :colorscheme PaperColor<CR>
map <F3> :colorscheme apprentice<CR>
map <F4> :colorscheme hybrid_material<CR>
map <F5> :colorscheme hybrid_reverse<CR>
map <F6> :colorscheme jellybeans<CR>
map <F7> :colorscheme spacegray<CR>
map <F8> :colorscheme tender<CR>

" Color Settings
colorscheme gruvbox  
set background=dark

hi! Normal ctermbg=NONE guibg=NONE 
hi! NonText ctermbg=NONE guibg=NONE guifg=NONE ctermfg=NONE 
"Making background transparent in Alacritty by default

let g:limelight_conceal_ctermfg = 'gray'
let g:limelight_conceal_ctermfg = 240

" Goyo settings
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

" ||\\ //||
" || \// || Mackenzie Criswell
" || //\ || https://makc.co
" ||   \\|| https://github.com/makccr
