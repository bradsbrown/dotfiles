" AutoInstall Plug if not already present
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
      \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

" Plug Stuff
filetype off
call plug#begin()
" Plug 'neoclide/coc.nvim', {'do': 'yarn install --frozen-lockfile'}
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'ctrlpvim/ctrlp.vim'
Plug 'scrooloose/nerdtree'
Plug 'jlanzarotta/bufexplorer'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
" Plug 'mileszs/ack.vim'
Plug 'tpope/vim-commentary'
Plug 'bling/vim-airline'
Plug 'jiangmiao/auto-pairs'
Plug 'petobens/poet-v'
Plug 'jaxbot/semantic-highlight.vim'
" if !has('nvim')
Plug 'psf/black', { 'tag': '20.8b1' }
" endif
Plug 'sheerun/vim-polyglot'
Plug 'martinda/Jenkinsfile-vim-syntax'
Plug 'gu-fan/riv.vim'
Plug 'christoomey/vim-tmux-navigator'
Plug 'junegunn/vim-easy-align'
if !has('nvim')
    Plug 'heavenshell/vim-pydocstring'
endif
if has('nvim')
    let $GH_USER = "brad2913"
    let $GH_PASS = "asdf"
    let g:critiq_github_url = "https://github.rackspace.com/api/v3"
    let g:critiq_github_oauth = 1
    Plug('AGhost-7/critiq.vim')
    Plug 'vimlab/split-term.vim'
endif
call plug#end()

" GHE for fugitive/rhubarb
let g:github_enterprise_urls = ['https://github.rackspace.com']

" Poet-V Airline integration
let g:airline#extensions#poetv#enabled = 1

" Vim Easy Align
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

" Basic Stuff
syntax on
filetype on
filetype plugin indent on
set nocompatible
colors PaperColor
if has("gui_macvim")
    set macligatures
   set guifont=Fira\ Code\ Retina:h14
elseif !has("nvim")
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
set foldlevelstart=99

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

" Window Split Navigation
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
set splitbelow
set splitright

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
autocmd Filetype cucumber setlocal ts=2 sw=2 expandtab  " Special tab settings for Gherkin files
autocmd Filetype javascript setlocal ts=2 sw=2 expandtab  " Special tab settings for Gherkin files

" Better Git Stuff
autocmd FileType gitcommit setlocal spell
autocmd FileType gitcommit call setpos('.', [0, 1, 1, 0])

" markdown handling
autocmd BufRead, BufNewFile *.md set filetype=Markdown
au Filetype Markdown setlocal wrap textwidth=80

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
let mapleader = "\<Space>"
nmap <Leader>8 :call Flake8()<CR>
" nmap <Leader>b :Black<CR>

" Triger `autoread` when files changes on disk
set autoread
" https://unix.stackexchange.com/questions/149209/refresh-changed-content-of-file-opened-in-vim/383044#383044
" https://vi.stackexchange.com/questions/13692/prevent-focusgained-autocmd-running-in-command-line-editing-mode
autocmd FocusGained,BufEnter,CursorHold,CursorHoldI * if mode() != 'c' | checktime | endif
" Notification after file change
" https://vi.stackexchange.com/questions/13091/autocmd-event-for-autoread
autocmd FileChangedShellPost *
  \ echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None

" Flake8 Stuff
autocmd FileType python map <buffer> <leader>8 :call Flake8()<CR>
let g:pylint_map='<leader>l'
let g:pyflakes_use_quickfix=1
let g:flake8_show_in_gutter=1
let g:flake8_show_in_file=1

" Ack setup
if executable('ag')
    let g:ackprg = 'ag --vimgrep'
    set grepprg=ag\ --nogroup\ --nocolor
endif

" Ctrlp
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_regexp = 1
let g:ctrlp_user_command = 'rg %s --files --color=never --glob ""'
let g:ctrlp_use_caching = 0

" JSON Handling
nmap <Leader>j :%!python -m json.tool<CR>

" NerdTree
map <C-n> :NERDTreeToggle<CR>

function! NERDTreeHighlightFile(extension, fg, bg, guifg, guibg)
 exec 'autocmd filetype nerdtree highlight ' . a:extension .' ctermbg='. a:bg .' ctermfg='. a:fg .' guibg='. a:guibg .' guifg='. a:guifg
 exec 'autocmd filetype nerdtree syn match ' . a:extension .' #^\s\+.*'. a:extension .'$#'
endfunction

call NERDTreeHighlightFile('py', 'green', 'none', 'green', '#151515')
call NERDTreeHighlightFile('json', 'blue', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('js', 'red', 'none', '#ffa500', '#151515')
call NERDTreeHighlightFile('html', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('css', 'cyan', 'none', 'cyan', '#151515')
call NERDTreeHighlightFile('rst', 'magenta', 'none', '#ff00ff', '#151515')
call NERDTreeHighlightFile('md', 'magenta', 'none', '#3366FF', '#151515')

" BufExplorer
nnoremap <silent> <M-F12> :BufExplorer<CR>
nnoremap <silent> <F12> :bn<CR>
nnoremap <silent> <S-F12> :bp<CR>

" Pydocstring
let g:pydocstring_templates_dir = '~/.vim/pydocstring_templates'
nmap <silent> <C-m> <Plug>(pydocstring)

" Semantic Highlight
nnoremap <Leader>h :SemanticHighlightToggle<cr>

" coc.vim
set hidden
set nobackup
set nowritebackup
set cmdheight=2
set updatetime=300
set shortmess+=c
set signcolumn=yes
" let g:coc_force_debug = 1
inoremap <silent><expr> <TAB>
    \ pumvisible() ? "\<C-n>" :
    \ <SID>check_back_space() ? "\<TAB>" :
    \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1] =~# '\s'
endfunction

nmap <leader>b :CocCommand python.sortImports<CR> :Black<CR>

inoremap <silent><expr> <c-space> coc#refresh()
if exists('*complete_info')
    inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
    inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif
nmap <silent> [c <Plug>(coc-diagnostic-prev)
nmap <silent> ]c <Plug>(coc-diagnostic-next)
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
    if (index(['vim','help'], &filetype) >= 0)
        execute 'h '.expand('<cword>')
    else
        call CocAction('doHover')
    endif
endfunction

autocmd CursorHold * silent call CocActionAsync('highlight')
nmap <leader>rn <Plug>(coc-rename)
xmap <leader>f <Plug>(coc-format-selected)
nmap <leader>f <Plug>(coc-format-selected)
command! -nargs=0 OR :call CocAction('runCommand', 'editor.action.organizeImport')
nnoremap <silent> <space>a :<C-u>CocList diagnostics<cr>
nnoremap <silent> <space>e :<C-u>CocList extensions<cr>
nnoremap <silent> <space>c :<C-u>CocList commands<cr>
nnoremap <silent> <space>o :<C-u>CocList outline<cr>
nnoremap <silent> <space>s :<C-u>CocList -I symbols<cr>
