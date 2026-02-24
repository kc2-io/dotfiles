" =============================================================================
" .vimrc — Vim configuration
" =============================================================================

" General
set nocompatible              " Use Vim defaults (not Vi)
set encoding=utf-8            " UTF-8 encoding
set fileencoding=utf-8

" UI
set number                    " Show line numbers
set relativenumber            " Relative line numbers
set cursorline                " Highlight current line
set showmatch                 " Highlight matching brackets
set showcmd                   " Show command in bottom bar
set wildmenu                  " Visual autocomplete for command menu
set laststatus=2              " Always show status line
set scrolloff=8               " Keep 8 lines above/below cursor

" Indentation
set tabstop=4                 " Tab width
set shiftwidth=4              " Indent width
set softtabstop=4             " Soft tab width
set expandtab                 " Use spaces instead of tabs
set autoindent                " Auto indent new lines
set smartindent               " Smart indentation

" Search
set incsearch                 " Incremental search
set hlsearch                  " Highlight search results
set ignorecase                " Case insensitive search...
set smartcase                 " ...unless uppercase is used

" Performance
set lazyredraw                " Don't redraw during macros
set ttyfast                   " Fast terminal connection

" Files
set nobackup                  " Don't create backup files
set noswapfile                " Don't create swap files
set autoread                  " Reload files changed outside vim

" Key mappings
let mapleader = " "           " Space as leader key
nnoremap <leader>w :w<CR>     " Quick save
nnoremap <leader>q :q<CR>     " Quick quit

" Clear search highlighting with Escape
nnoremap <Esc> :nohlsearch<CR>

" Enable syntax highlighting
syntax enable

" Enable filetype detection and plugins
filetype plugin indent on
