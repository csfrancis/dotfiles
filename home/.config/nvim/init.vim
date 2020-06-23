" BASIC
set nocompatible " No vi compatility, this first because it resets some options
let mapleader="," " Mapleader
filetype off
set encoding=utf-8
set history=1000  " Keep more history, default is 20
set rtp+=~/.config/nvim/bundle/neobundle.vim
call neobundle#begin(expand('~/.config/nvim/bundle/'))

NeoBundleFetch 'Shougo/neobundle.vim'

NeoBundle 'scrooloose/nerdtree'
NeoBundle 'scrooloose/syntastic'

NeoBundle 'tpope/vim-endwise'
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'tpope/vim-rhubarb'
NeoBundle 'tpope/vim-unimpaired'
NeoBundle 'tpope/vim-commentary'
NeoBundle 'junegunn/fzf', { 'dir': '~/.fzf', 'do': 'yes\| ./install' }
NeoBundle 'junegunn/fzf.vim'
NeoBundle 'roxma/vim-tmux-clipboard'
NeoBundle 'mileszs/ack.vim'

" Languages
NeoBundle 'tpope/vim-liquid'
NeoBundle 'gabrielelana/vim-markdown'
NeoBundle 'shime/vim-livedown'
NeoBundle 'tpope/vim-rails'
NeoBundle 'vim-ruby/vim-ruby'
NeoBundle 'vim-scripts/VimClojure'
NeoBundle 'kchmck/vim-coffee-script'
NeoBundle 'pangloss/vim-javascript'
NeoBundle 'fatih/vim-go'

NeoBundle 'junegunn/goyo.vim'

call neobundle#end()

filetype plugin indent on " Enable after Vundle loaded, #dunnolol

" Allow editing crontabs http://vim.wikia.com/wiki/Editing_crontab
set backupskip=/tmp/*,/private/tmp/* "
set undodir=~/.vim/undo
set noswapfile
set nobackup

set termguicolors

syntax enable
set background=dark " Set dark solarized theme
colorscheme NeoSolarized
set textwidth=80  " Switch line at 80 characters
set scrolloff=5   " Keep some distance to the bottom"
set showmatch     " Show matching of: () [] {}
set ignorecase    " Required for smartcase to work
set smartcase     " Case sensitive when uppercase is present
set incsearch     " Search as you type
set smartindent   " Be smart about indentation
set expandtab     " Tabs are spaces
set smarttab
set ruler

set tabstop=2 " Tabs are 2 spaces
set backspace=2 " Backspace deletes 2 spaces
set shiftwidth=2 " Even if there are tabs, preview as 2 spaces

set list " Highlight trailings, stolen from @teoljungberg
set listchars=tab:>-,trail:.,extends:>,precedes:<

set tags=tags,.git/tags " Use commit hook tags, see ~/.git_template

map <C-J> <C-W>j
map <C-K> <C-W>k
map <C-L> <C-W>l
map <C-H> <C-W>h
imap jk <esc>
map <leader>d :bd<CR>

" Sane behavior on long lines
nmap k gk
nmap j gj
noremap H ^
noremap L $

map <leader>gs :Gstatus<CR>
map <leader>gc :Gcommit<CR>

" Rename current file, thanks Gary Bernhardt via Ben Orenstein
function! RenameFile()
  let old_name = expand('%')
  let new_name = input('New file name: ', expand('%'), 'file')
  if new_name != '' && new_name != old_name
    exec ':saveas ' . new_name
    exec ':silent !rm ' . old_name
    redraw!
  endif
endfunction
map <leader>r :call RenameFile()<cr>

" Sane default tab-key, replaces Supertab.
function! InsertTabWrapper()
  let col = col('.') - 1
  if !col || getline('.')[col - 1] !~ '\k'
    return "\<tab>"
  else
    return "\<c-p>"
  endif
endfunction
imap <tab>   <c-r>=InsertTabWrapper()<cr>
imap <s-tab> <c-n>

au BufNewFile,BufRead *.ejson set filetype=json
au BufNewFile,BufRead *.sxx set filetype=stp

" MRI bullshit
au BufRead,BufNewFile */src/ruby/*.{c,h}    set sw=4 ts=8 softtabstop=8 noet

" LuaJIT bullshit
au BufRead,BufNewFile */src/LuaJIT/*.{c,h}  set sw=2 ts=8 softtabstop=2 noet

autocmd BufNewFile,BufRead *.md,*.markdown set spell

autocmd FileType go,gitcommit,qf,gitset setlocal nolist " Go fmt will use tabs

map <leader>n :NERDTreeToggle<CR>
map <leader>l :NERDTreeFind<CR>
let NERDTreeMapOpenSplit='s'
let NERDTreeMapOpenVSplit='v'

map <C-t> :Files<CR>
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-s': 'split',
  \ 'ctrl-v': 'vsplit' }


set splitright

cmap w!! w !sudo tee > /dev/null % 2>&1

set wildignore+=.git/**,public/assets/**,vendor/**,log/**,tmp/**,Cellar/**,app/assets/images/**,_site/**,home/.vim/bundle/**,**/.gitkeep,**/.DS_Store,**/*.netrw*,node_modules/*

map <leader>gb :Gblame<CR>
map <leader>gd :Gdiff<CR>
map <leader>gs :Gstatus<CR>
map <leader>gB :Gbrowse<CR>

autocmd Syntax c,cpp,vim,xml,html,xhtml setlocal foldmethod=syntax
autocmd Syntax c,cpp,vim,xml,html,xhtml normal zR

if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif

" Searching
nmap <M-e> :Ack! "\b<cword>\b"<CR>
nmap <M-g> :Ggrep! "\b<cword>\b"<CR>

let g:syntastic_cpp_compiler_options = ' -std=c++11 -Wall -Wextra'
