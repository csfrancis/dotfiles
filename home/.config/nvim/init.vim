" BASIC
let mapleader="," " Mapleader

" Plugins are managed by Neovim's built-in vim.pack and install on first launch.
" Update them with :lua vim.pack.update(). Versions are pinned in
" nvim-pack-lock.json next to this file.
lua << EOF
local gh = function(repo) return 'https://github.com/' .. repo end
vim.pack.add({
  gh('preservim/nerdtree'),
  gh('tpope/vim-endwise'),
  gh('tpope/vim-fugitive'),
  gh('tpope/vim-rhubarb'),
  gh('junegunn/fzf'),
  gh('junegunn/fzf.vim'),
  gh('mileszs/ack.vim'),
  gh('junegunn/goyo.vim'),
  gh('overcache/NeoSolarized'),

  -- Languages
  gh('tpope/vim-rails'),
  gh('fatih/vim-go'),
  gh('neovim/nvim-lspconfig'), -- Language server configs, enabled below
}, { confirm = false })
EOF

set undofile " Keep undo history across restarts
set noswapfile
set nobackup

set termguicolors

set background=dark " Set dark solarized theme
colorscheme NeoSolarized
set scrolloff=5   " Keep some distance to the bottom"
set showmatch     " Show matching of: () [] {}
set ignorecase    " Required for smartcase to work
set smartcase     " Case sensitive when uppercase is present
set expandtab     " Tabs are spaces

set tabstop=2 " Tabs are 2 spaces
set softtabstop=-1 " Backspace removes a whole indent level (uses shiftwidth)
set shiftwidth=2 " Even if there are tabs, preview as 2 spaces

set list " Highlight trailings, stolen from @teoljungberg
set listchars=tab:>-,trail:.,extends:>,precedes:<

noremap <C-J> <C-W>j
noremap <C-K> <C-W>k
noremap <C-L> <C-W>l
noremap <C-H> <C-W>h
inoremap jk <esc>
noremap <leader>d :bd<CR>

" Sane behavior on long lines. A count (5j) still moves by real lines.
nnoremap <expr> k v:count ? 'k' : 'gk'
nnoremap <expr> j v:count ? 'j' : 'gj'
noremap H ^
noremap L $

noremap <leader>gs :Git<CR>
noremap <leader>gc :Git commit<CR>
noremap <leader>gb :Git blame<CR>
noremap <leader>gd :Gdiffsplit<CR>
noremap <leader>gB :GBrowse<CR>

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
noremap <leader>r :call RenameFile()<cr>

" Sane default tab-key, replaces Supertab.
function! InsertTabWrapper()
  let col = col('.') - 1
  if !col || getline('.')[col - 1] !~ '\k'
    return "\<tab>"
  else
    return "\<c-p>"
  endif
endfunction
inoremap <expr> <tab> InsertTabWrapper()
inoremap <s-tab> <c-n>

augroup vimrc
  autocmd!
  autocmd BufNewFile,BufRead *.ejson set filetype=json
  autocmd BufNewFile,BufRead *.sxx set filetype=stp

  " Hard-wrap prose only. Git commit messages wrap at 72 via Neovim's gitcommit
  " filetype plugin.
  autocmd FileType markdown setlocal spell textwidth=80

  autocmd FileType go,gitcommit,qf setlocal nolist " Go fmt will use tabs

  autocmd Syntax c,cpp,vim,xml,html,xhtml setlocal foldmethod=syntax
  autocmd Syntax c,cpp,vim,xml,html,xhtml normal zR
augroup END

noremap <leader>n :NERDTreeToggle<CR>
noremap <leader>l :NERDTreeFind<CR>
let NERDTreeMapOpenSplit='s'
let NERDTreeMapOpenVSplit='v'

noremap <C-t> :Files<CR>
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-s': 'split',
  \ 'ctrl-v': 'vsplit' }


set splitright

set wildignore+=.git/**,public/assets/**,vendor/**,log/**,tmp/**,Cellar/**,app/assets/images/**,_site/**,**/.gitkeep,**/.DS_Store,**/*.netrw*,node_modules/*

if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif

" Searching
nnoremap <M-e> :Ack! "\b<cword>\b"<CR>
nnoremap <M-g> :Ggrep! "\b<cword>\b"<CR>

" Language servers, using configs from nvim-lspconfig. Go is handled by vim-go.
" Servers: clangd (Xcode tools), brew install jdtls vtsls vue-language-server
lua << EOF
-- TypeScript in .vue files goes through vtsls with Vue's TypeScript plugin,
-- which ships inside vue-language-server.
local vue_ls_bin = vim.fn.exepath('vue-language-server')
if vue_ls_bin ~= '' then
  vim.lsp.config('vtsls', {
    settings = {
      vtsls = {
        tsserver = {
          globalPlugins = {
            {
              name = '@vue/typescript-plugin',
              location = vim.fn.fnamemodify(vim.fn.resolve(vue_ls_bin), ':h:h'),
              languages = { 'vue' },
              configNamespace = 'typescript',
            },
          },
        },
      },
    },
    filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' },
  })
end

vim.lsp.enable({ 'clangd', 'jdtls', 'vtsls', 'vue_ls' })
vim.diagnostic.config({ virtual_text = true })
EOF
