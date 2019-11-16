call plug#begin('~/.vim/plugged')  "Installing vim plugins
    Plug 'junegunn/goyo.vim'  "Simple writing theme that looks nice with markdown
    Plug 'vim-airline/vim-airline'
    Plug 'airblade/vim-gitgutter'
    Plug 'vim-airline/vim-airline-themes' "Making Vim look sexier than Emacs
    Plug 'morhetz/gruvbox'
    Plug 'ap/vim-css-color'
call plug#end()

if &term =~ '256color'
    set t_ut=
endif "This is necessary when using with the Ubuntu subsystem on Windows 10

set encoding=UTF-8
filetype plugin indent on  "Enabling Plugin & Indent
syntax on  "Turning Syntax on
filetype plugin on
filetype indent on
set autoread
set wildmenu "Tab completion everywhere, why this isn't default we will never know
colorscheme gruvbox  "Setting up Gruvbox and airline, (colors)
set background=dark "duh
    let g:airline_theme='gruvbox'
    let g:gruvbox_underline = '1'
    let g:gruvbox_italic = '1'
    let g:gruvbox_bold = '1'
    let g:gruvbox_contrast_dark = 'hard' 
    let g:gruvbox_contrast_light = 'hard' 
    let g:gruvbox_termcolors = '256'
set number relativenumber  "Setting line numbers
set nu rnu
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
set laststatus=2  "Set command height to 2 so nothing gets cut off
set cmdheight=1

au BufRead,BufNewFile *.fountain set filetype=fountain "Enabling fountain syntax

"Key re-maps
map <C-n> :Sex<CR>
map <C-g> :Goyo<CR>
map <C-u> :source ~/.vimrc<CR>
map <C-i> :set background=dark<CR>
map <C-o> :set background=light<CR> 
