let mapleader = ","
set nocompatible            " Disable compatibility to old-time vi
set showmatch               " Show matching brackets.
set ignorecase              " Do case insensitive matching
set mouse=v                 " middle-click paste with mouse set tabstop=4               " number of columns occupied by a tab character
set softtabstop=4           " see multiple spaces as tabstops so <BS> does the right thing
set expandtab               " converts tabs to white space
set shiftwidth=4            " width for autoindents
set autoindent              " indent a new line the same amount as the line just typed
set number                  " add line numbers
set wildmode=longest,list   " get bash-like tab completions
"set cc=80                   " set an 80 column border for good coding style
set splitright
set splitbelow
set exrc
set secure
set nohlsearch


" set the runtime path to include VimPlug and initialize
call plug#begin('~/.local/share/nvim/plugged')

Plug 'junegunn/vim-plug'
Plug 'airblade/vim-gitgutter'
Plug 'bling/vim-airline'
Plug 'arcticicestudio/nord-vim'
Plug 'danilo-augusto/vim-afterglow'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'lnl7/vim-nix'
Plug 'w0rp/ale'
Plug 'guns/vim-sexp'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-rooter'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-surround'
Plug 'clojure-vim/acid.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'vigemus/impromptu.nvim'
Plug 'clojure-vim/jazz.nvim'
Plug 'shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'clojure-vim/async-clj-omni'
Plug 'guns/vim-clojure-static'
Plug 'scrooloose/nerdtree'
Plug 'scrooloose/nerdcommenter'
Plug 'brooth/far.vim'
Plug 'ntpeters/vim-better-whitespace'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
"Plug 'nsf/gocode', { 'rtp': 'nvim', 'do': '~/.config/nvim/plugged/gocode/nvim/symlink.sh' }
"Plug 'deoplete-plugins/deoplete-go', { 'do': 'make'}
Plug 'kassio/neoterm'
Plug 'preservim/tagbar'

" All of your Plugins must be added before the following line
call plug#end()

" Color Scheme
"colorscheme afterglow

" Plugin Config
let g:ctrlp_root_markers = ['project.clj', 'deps.edn', 'go.mod', 'shell.nix']
let g:ctrlp_show_hidden = 1

let g:rooter_change_directory_for_non_project_files = 'home'
let g:rooter_patterns = ['go.mod', 'project.clj', 'deps.edn', '.git/', 'shell.nix']

let g:neoterm_autoscroll = 1

" Use deoplete.
let g:deoplete#enable_at_startup = 1

" <TAB> Completeion
function! s:check_back_space() abort "{{{
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~ '\s'
endfunction"}}}
inoremap <silent><expr> <TAB>
            \ pumvisible() ? "\<C-n>" :
            \ <SID>check_back_space() ? "\<TAB>" :
            \ deoplete#manual_complete()

augroup init
    autocmd!
    autocmd QuickFixCmdPost *grep* cwindow
    autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
augroup END
"autocmd bufenter * if (winnr("$") >= 1) | only | else | q | endif

let g:NERDDefaultAlign = 'left'
"let g:far#auto_preview = 0
let g:far#debug = 1

let g:better_whitespace_enabled=1
let g:strip_whitespace_on_save=1

let g:neoterm_default_mod='belowright'
let g:ale_java_javac_classpath='../../bin'

" Mappings
nmap \ <C-^>
nmap ;; <C-w><C-w>
nmap ;j <C-w>j
nmap ;k <C-w>k
nmap ;h <C-w>h
nmap ;l <C-w>l

nmap <leader>w :w!<CR>
nmap <leader>s :w!<CR>
nmap <leader>e :CtrlPMRU<CR>
nmap <leader>f :CtrlPMixed<CR>
nmap <leader>q :q!<CR>
nmap <leader>tl :vertical Tnew<CR>
nmap <leader>tj :Tnew<CR>
nmap <leader>nt :NERDTreeToggle<CR>
nmap <leader>1 :only<CR>
nmap \| :vsp<CR>
nmap _ :sp<CR>

imap ii <Esc>
tnoremap ii <C-\><C-n>
tnoremap kk <C-\><C-n>:q<CR>

" toggle spelling
" nnoremap <leader>s :set invspell<CR>

"clojure
augroup clj
    autocmd!
    autocmd FileType clojure nmap <buffer> <leader>f <M-S-l>
    autocmd FileType clojure nmap <buffer> <leader>F <M-S-h>
    autocmd FileType clojure nmap <buffer> ff :CtrlPMixed<CR>
    autocmd FileType clojure nmap <buffer> <leader>g <M-S-k>
    autocmd FileType clojure nmap <buffer> <leader>G <M-S-j>
    autocmd FileType clojure nmap <buffer> <leader>x d)
    autocmd FileType clojure nmap <buffer> <leader>r :lua require('acid.nrepl').start({})<CR>
    autocmd FileType clojure nmap <buffer> <leader>v cpp
    autocmd FileType clojure nmap <buffer> <leader>c :AcidClearVtext<CR>
augroup END

if has("autocmd")
   let conEmuMacro = "!/mnt/c/Program\ Files/ConEmu/ConEmu/ConEmuC64.exe -guimacro setoption check"
   let beamCursor = conEmuMacro . " 2531 " . "1 >/dev/null 2>&1 &"
   let blockCursor = conEmuMacro . " 2532 " . "1 >/dev/null 2>&1 &"

   au VimLeave * silent execute beamCursor | redraw!
   au VimEnter * silent execute blockCursor | redraw!

   au InsertEnter * silent execute beamCursor | redraw!
   au InsertLeave * silent execute blockCursor | redraw!
endif

"go
augroup go
    autocmd!
    autocmd FileType go nmap <buffer> <leader>r :T go run %<CR>
augroup END
