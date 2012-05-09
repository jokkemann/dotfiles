version 4.0

if matchend($LC_CTYPE, 'UTF-8') >= 0
	set encoding=utf-8
endif

if exists("*pathogen#infect")
	call pathogen#infect()
endif

filetype plugin on
filetype indent on
syntax on
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
