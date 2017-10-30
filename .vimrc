set nocompatible
version 4.0

let mapleader=","

if matchend($LC_CTYPE, 'UTF-8') >= 0
	set encoding=utf-8
endif

silent! call pathogen#infect()
" silent! call pathogen#helptags()

filetype plugin on
filetype indent on
syntax on
set t_Co=256
colorscheme koehler
set background=dark
set number
set mouse=a
set nowrap
set tabstop=4
set shiftwidth=4
set smartindent
set hlsearch

" CUSTOM COMMANDS AND MAPPINGS
" Avoid holding shift in normal mode
noremap ; :
" noremap : ;

" Toggle higlight search
nnoremap <Esc><Esc> :set hlsearch!<CR>

" Toggle highlighting of special chars
nnoremap <Space> :set list!<CR>

" Shift blocks and keep visual selection
vnoremap < <gv
vnoremap > >gv

" Faster scrolling with Ctrl+j/k, cursor at bottom/top
noremap <C-j> 3<C-e>L
noremap <C-k> 3<C-y>H

nnoremap <leader>ev :vsplit $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>

"inoremap <esc> <nop> " Won't work since arrows send the <esc>-char
inoremap jk <esc>

nnoremap <up> <nop>
nnoremap <right> <nop>
nnoremap <down> <nop>
nnoremap <left> <nop>
inoremap <up> <nop>
inoremap <right> <nop>
inoremap <down> <nop>
inoremap <left> <nop>

" ctrlp.vim exclusions
set wildignore+=*/node_modules/*
let g:ctrlp_clear_cache_on_exit = 0
