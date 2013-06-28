version 4.0

if matchend($LC_CTYPE, 'UTF-8') >= 0
	set encoding=utf-8
endif

silent! call pathogen#infect()

filetype plugin on
filetype indent on
syntax on
set t_Co=256
colorscheme koehler
set nocompatible
set background=dark
set number
set mouse=a
set nowrap
set tabstop=8
set shiftwidth=8
set smartindent
set hlsearch

autocmd		FileType	php	set	omnifunc=phpcomplete#CompletePHP

autocmd		FileType	php	set	dictionary-=$HOME/.vim/phpfunclist.txt dictionary+=$HOME/.vim/phpfunclist.txt
autocmd		FileType	php	set	complete-=k complete+=k

autocmd 	FileType	perl	ia	podii	0i=item B<> I<>=cutk0

autocmd		FileType	perl	ia	headii	1Go=head1 NAME -
	\=head1 SYNOPSIS
	\use ;=head1 DESCRIPTION
	\=head1 METHODS
	\=over 4=cut


autocmd 	FileType	php	ia	podii	0i	/*pod=item B<> I<>=cutpod*/k0
autocmd		FileType	php	ia	headii	1Go/*pod=head1 NAME -
	\=head1 SYNOPSIS
	\require_once();=head1 DESCRIPTION
	\=head1 METHODS
	\=over 4pod*/


" CUSTOM COMMANDS AND MAPPINGS
" Avoid holding shift in normal mode
noremap ; :
noremap : ;

" Toggle higlight search
nnoremap <Esc><Esc> :set hlsearch!<CR>

" Toggle highlighting of special chars
nnoremap <Space> :set list!<CR>

" Shift blocks and keep visual selection
vnoremap < <gv
vnoremap > >gv

" Faster scrolling with Ctrl+j/k, cursor at bottom/top
map <C-j> 3<C-e>L
map <C-k> 3<C-y>H
