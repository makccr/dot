call plug#begin('~/.vim/plugged')  "Installing vim plugins
Plug 'junegunn/goyo.vim'  "Simple writing theme that looks nice with markdown
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'airblade/vim-gitgutter'
Plug 'NLKNguyen/papercolor-theme' "Color-schemes and color customization
Plug 'morhetz/gruvbox'
Plug 'joshdick/onedark.vim'
Plug 'ap/vim-css-color'
call plug#end()

if &term =~ '256color'
    set t_ut=
endif

set encoding=UTF-8
filetype plugin indent on  "Enabling Plugin & Indent
syntax on  "Turning Syntax on
filetype plugin on
filetype indent on 
set autoread
set wildmenu
colorscheme gruvbox  "Setting up Vim's theme
set background=dark
let g:airline_theme='gruvbox' 
set number relativenumber  "Setting line numbers 
set nu rnu
set spell  "Turning spell check on
set backspace=indent,eol,start  "Making sure backspace works
set noruler  "Setting up rulers & spacing, tabs 
set confirm
set shiftwidth=4
set autoindent
Plug 'junegunn/fzf.vim'
set smartindent
set tabstop=4
set softtabstop=4
set expandtab  
set hls is  "Making sure search highlights words as we type them
set ic
set laststatus=2  "Set command height to 2 so nothing gets gut off
set cmdheight=2
let g:indent_guides_guide_size = 1  "Enabling indent guides
let g:indent_guides_color_change_percent = 3
let g:indent_guides_enable_on_vim_startup = 1

"Key re-maps
map <C-n> :Sex<CR> 
map <C-g> :Goyo<CR>
map <C-y> :colorscheme gruvbox<CR>
map <C-u> :colorscheme onedark<CR>
map <C-i> :colorscheme PaperColor<CR>
