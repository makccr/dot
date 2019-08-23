filetype plugin indent on
syntax on
colorscheme gruvbox 
set background=dark
set number
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

augroup markdownSpell
    autocmd!
    autocmd FileType markdown setlocal spell
    autocmd FileType markdown setlocal nonumber
    autocmd FileType markdown colorscheme onedark
    autocmd BufRead,BufNewFile *.md setlocal spell
    autocmd BufRead,BufNewFile *.md setlocal nonumber
    autocmd BufRead,BufNewFile *.md colorscheme onedark
augroup END

augroup txtSpell
    autocmd!
    autocmd FileType text setlocal spell
    autocmd FileType text setlocal nonumber
    autocmd FileType text colorscheme onedark
    autocmd BufRead,BufNewFile *.txt setlocal spell
    autocmd BufRead,BufNewFile *.txt setlocal nonumber
    autocmd BufRead,BufNewFile *.txt colorscheme onedark
augroup END

let g:lightline = {
    \ 'colorscheme': 'seoul256',
    \ }

call plug#begin('~/.vim/plugged')
Plug 'junegunn/goyo.vim'
Plug 'airblade/vim-gitgutter'
Plug 'https://github.com/scrooloose/nerdtree.git'
Plug 'itchyny/lightline.vim'
Plug 'morhetz/gruvbox'
Plug 'joshdick/onedark.vim'
Plug 'nathanaelkane/vim-indent-guides'
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'
call plug#end()
