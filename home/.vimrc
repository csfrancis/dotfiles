" BASIC
set nocompatible " No vi compatility, this first because it resets some options
let mapleader="," " Mapleader
filetype off
set encoding=utf-8
set history=1000  " Keep more history, default is 20
set rtp+=~/.vim/bundle/neobundle.vim
call neobundle#begin(expand('~/.vim/bundle/'))

NeoBundleFetch 'Shougo/neobundle.vim'
NeoBundle 'teoljungberg/vim-grep'

NeoBundle 'scrooloose/nerdtree'
NeoBundle 'scrooloose/syntastic'

NeoBundle 'tpope/vim-endwise'
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'tpope/vim-unimpaired'
NeoBundle 'tpope/vim-commentary'

NeoBundle 'wincent/Command-T'
NeoBundle 'altercation/vim-colors-solarized'

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

call neobundle#end()

filetype plugin indent on " Enable after Vundle loaded, #dunnolol

" Allow editing crontabs http://vim.wikia.com/wiki/Editing_crontab
set backupskip=/tmp/*,/private/tmp/* "
set undodir=~/.vim/undo
set noswapfile
set nobackup

syntax enable
set background=dark " Set dark solarized theme
colorscheme solarized
set t_Co=256  " 2000s plz
set textwidth=80  " Switch line at 80 characters
set scrolloff=5   " Keep some distance to the bottom"
set showmatch     " Show matching of: () [] {}
set ignorecase    " Required for smartcase to work
set smartcase     " Case sensitive when uppercase is present
set incsearch     " Search as you type
set smartindent   " Be smart about indentation
set expandtab     " Tabs are spaces
set smarttab
set shell=$SHELL\ -l  " load shell for ruby version etc.
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

autocmd BufNewFile,BufRead *.md,*.markdown set spell

autocmd FileType go,gitcommit,qf,gitset setlocal nolist " Go fmt will use tabs

map <leader>n :NERDTreeToggle<CR>
map <leader>l :NERDTreeFind<CR>

map <C-t> :CommandT<CR>
map <C-g> :CommandTBuffer<CR>
map <C-/> :CommandTTag<CR>
let g:CommandTMaxHeight=20
let g:CommandTMaxFiles=10000

cmap w!! w !sudo tee > /dev/null %

set shell=bash\ --login

set wildignore+=.git/**,public/assets/**,vendor/**,log/**,tmp/**,Cellar/**,app/assets/images/**,_site/**,home/.vim/bundle/**,**/.gitkeep,**/.DS_Store,**/*.netrw*,node_modules/*
