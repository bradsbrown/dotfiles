" Plug Stuff
filetype off
call plug#begin()
Plug 'ctrlpvim/ctrlp.vim'
Plug 'nvie/vim-flake8'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
Plug 'maralla/completor.vim'
Plug 'bling/vim-airline'
Plug 'jiangmiao/auto-pairs'
call plug#end()

" Basic Stuff
syntax on
filetype on
filetype plugin indent on
set nocompatible
colors zenburn
if has("gui_macvim")
   set guifont=Source\ Code\ Pro\ Light:h14
else
   set guifont=Source\ Code\ Pro:h12
endif
set nowrap                          " Don't wrap text
command! W :w                       " Map W to w

" Editing Stuff
set number                          " add line numbers
set ruler                           " display cursor location info
set cursorline                      " highlight active cursor line
set showmatch                       " mark open/close punctuation when typing
set backspace=indent,eol,start      " helps with backspace in insert mode
set spelllang=en_us
set tildeop


" Menu Stuff
set wildmenu                        " Menu completion on tab
set wildmode=longest,full           " tab cycles between options
set wildignore=*.pyc,*.pyo,*.pyd    " exclude files

" GUI Stuff
set laststatus=2

" Vim Tab Stuff
map <silent> <C-Tab> :tabnext<CR>
imap <silent> <C-Tab> <Esc>:tabnext<CR>
map <silent> <C-S-Tab> :tabprevious<CR>
imap <silent> <C-S-Tab> <Esc>:tabprevious<CR>
map <silent> <C-t> :tabnew<CR>
imap <silent> <C-t> <Esc><C-t>

" Search Stuff
set hlsearch                        " search highlighting
set incsearch                       " dynamic highlighting
set ignorecase                      " ignore case in search by default
set smartcase                       " case sensitive if caps present

" Tab Stuff
set tabstop=4
set shiftwidth=4
set expandtab
set shiftround                      " indent/oudent to nearest tabstop
set autoindent                      " auto indent
set list                            " show all chars
set listchars=tab:>-                " show tab chars clearly

" Better Git Stuff
autocmd FileType gitcommit setlocal spell
autocmd FileType gitcommit call setpos('.', [0, 1, 1, 0])

" Remove trailing whitespace on save
autocmd BufWritePre * :%s/\s\+$//e

" Show characters that go over 79 chars for Python files
if exists('+colorcolumn')
   autocmd FileType python set colorcolumn=80,100
   highlight ColorColumn guibg=#262626
else
   autocmd FileType python highlight OverLength ctermbg=red ctermfg=white guibg=#592929
   autocmd FileType python match OverLength /\%80v.\+/
endif

" Toggle Line Numbering mode
function! g:ToggleNuMode()
   if(&rnu == 1)
       set nu
   else
       set rnu
   endif
endfunc
nnoremap <C-l> :call g:ToggleNuMode()<CR>

" Flake8 Stuff
autocmd FileType python map <buffer> <leader>8 :call Flake8()<CR>
let g:pylint_map='<leader>l'
let g:pyflakes_use_quickfix=1
let g:flake8_show_in_gutter=1
let g:flake8_show_in_file=1

" Ctrlp
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_regexp = 1
