" -------------------------------- Plugins (VimPlug) --------------------------
call plug#begin('~/.vim/plugged')  
" Tools
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    Plug 'airblade/vim-gitgutter' 
    Plug 'junegunn/goyo.vim'  
    Plug 'preservim/nerdtree'
    Plug 'ryanoasis/vim-devicons'
" Syntax
    Plug 'tpope/vim-markdown'
    Plug 'ap/vim-css-color' "Displays a preview of colors with CSS 
    Plug 'vim-scripts/fountain.vim'
" Color-schemes
    Plug 'morhetz/gruvbox' "My favorite theme
call plug#end() 
 
" ---------------------------- General Settings ------------------------------
set encoding=UTF-8
filetype plugin indent on  "Enabling Plugin & Indent
syntax on  "Turning Syntax on
set autoread
set wildmenu
set number relativenumber  "Setting line numbers
set nu rnu
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

" --------------------------- Syntax Mappings --------------------------------
au BufRead,BufNewFile *.fountain set filetype=fountain "Enabling fountain syntax

" ---------------------------- Key Remapping ---------------------------------
map <C-n> :NERDTreeToggle<CR>
map <C-g> :Goyo<CR>
map <C-u> :source ~/.vimrc<CR>
map <C-b> :set spelllang=de_de<CR>
nnoremap <Up>    :resize +2<CR> 
nnoremap <Down>  :resize -2<CR>
nnoremap <Left>  :vertical resize +2<CR>
nnoremap <Right> :vertical resize -2<CR>

" ----------------------------- Color Settings -------------------------------
colorscheme gruvbox  
let g:airline_theme='gruvbox'
set background=dark

" -------------------------------- Connect -----------------------------------
" https://makc.co
" https://github.com/makccr
