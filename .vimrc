call plug#begin('~/.vim/plugged')  "Installing vim plugins
    Plug 'vim-airline/vim-airline' "Setting up my status bar
    Plug 'vim-airline/vim-airline-themes'
    Plug 'airblade/vim-gitgutter' "Shows changes if you're working with git
    Plug 'junegunn/goyo.vim'  "Simple writing theme that looks nice with markdown

    "Color-schemes, some additional color schemes just live in .vim/colors
    Plug 'ap/vim-css-color' "Displays a preview of colors with CSS (like VS Code)
    Plug 'morhetz/gruvbox' "My favorite theme
    Plug 'davidosomething/vim-colors-meh' 
call plug#end() 

set encoding=UTF-8
filetype plugin indent on  "Enabling Plugin & Indent
syntax on  "Turning Syntax on
filetype plugin on
filetype indent on
set autoread
set wildmenu "Tab completion everywhere, it's awesome
    let g:gruvbox_underline = '1'
    let g:gruvbox_italic = '1'
    let g:gruvbox_bold = '1'
    let g:gruvbox_contrast_dark = 'hard' 
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
set laststatus=2 "Setting the size for the command area, and airline status bar
set cmdheight=1 

au BufRead,BufNewFile *.fountain set filetype=fountain "Enabling fountain syntax

"Key re-maps
map <C-n> :Lex!<CR>
map <C-b> :vertical resize 30<CR>
map <C-g> :Goyo<CR>
map <C-u> :source ~/.vimrc<CR>

"I occasionally use a Ubuntu subsystem on Windows 10, which requires some
"additional configuration to fix terminal colors & enable underlining for my
"default theme, Gruvbox. 
augroup SpellUnderline " Force to use underline for spell check results and apply gruvbox theme
  autocmd!
  autocmd ColorScheme *
    \ highlight SpellBad
    \   cterm=Underline
    \   ctermfg=NONE
    \   ctermbg=NONE
    \   term=Reverse
    \   gui=Undercurl
    " \   guisp=Red
  autocmd ColorScheme *
    \ highlight SpellCap
    \   cterm=Underline
    \   ctermfg=NONE
    \   ctermbg=NONE
    \   term=Reverse
    \   gui=Undercurl
    " \   guisp=Red
  autocmd ColorScheme *
    \ highlight SpellLocal
    \   cterm=Underline
    \   ctermfg=NONE
    \   ctermbg=NONE
    \   term=Reverse
    \   gui=Undercurl
    " \   guisp=Red
  autocmd ColorScheme *
    \ highlight SpellRare
    \   cterm=Underline
    \   ctermfg=NONE
    \   ctermbg=NONE
    \   term=Reverse
    \   gui=Undercurl
    " \   guisp=Red
  augroup END

if &term =~ '256color'
    set t_ut=
endif "Fixing issues with terminal colors

"Color schemes need to be below everything else that effects color apparently.
"If no things will load out of order and not work properly. 
colorscheme gruvbox  "Setting up Gruvbox and airline, (colors)
set background=dark 
let g:airline_theme='gruvbox'
