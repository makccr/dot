filetype plugin indent on
syntax on
colorscheme gruvbox
set background=dark
set number relativenumber
set nu rnu
set spell
set backspace=indent,eol,start
set noruler
set confirm
set shiftwidth=4
set autoindent
set smartindent
set tabstop=4
set softtabstop=4
set expandtab
set hls is
set ic
set laststatus=2
set cmdheight=2
let g:indent_guides_guide_size = 1
let g:indent_guides_color_change_percent = 3
let g:indent_guides_enable_on_vim_startup = 1
map <C-n> :NERDTreeToggle<CR>

if !has('gui_running')
  set t_Co=256
endif

let g:airline_theme='gruvbox'

call plug#begin('~/.vim/plugged')
Plug 'junegunn/goyo.vim'
Plug 'airblade/vim-gitgutter'
Plug 'https://github.com/scrooloose/nerdtree.git'
Plug 'morhetz/gruvbox'
Plug 'joshdick/onedark.vim'
Plug 'nathanaelkane/vim-indent-guides'
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'
Plug 'ap/vim-css-color'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
call plug#end()
