"
"=============================
"#####  neovim config  #######
"=============================

"-----------------------------
"  General settings
"-----------------------------

set nowrap
set formatoptions=cqrn1
set tabstop=2 shiftwidth=2 softtabstop=2 expandtab
set autoindent
set smartindent
set splitbelow
set splitright
set hidden
set number relativenumber
set list
set listchars=tab:<=>,trail:·,extends:⤏,precedes:⤎
set scrolloff=8
set clipboard=unnamedplus
set wildmode=longest:full,full

"-----------------------
"  Plugins
"-----------------------

call plug#begin()
source $XDG_CONFIG_HOME/nvim/plugins/gruvbox.vim
source $XDG_CONFIG_HOME/nvim/plugins/fugitive.vim
source $XDG_CONFIG_HOME/nvim/plugins/airline.vim
source $XDG_CONFIG_HOME/nvim/plugins/commentary.vim
source $XDG_CONFIG_HOME/nvim/plugins/surround.vim
source $XDG_CONFIG_HOME/nvim/plugins/lsp-config.vim
source $XDG_CONFIG_HOME/nvim/plugins/polyglot.vim
source $XDG_CONFIG_HOME/nvim/plugins/fern.vim
source $XDG_CONFIG_HOME/nvim/plugins/telescope.vim
call plug#end()
doautocmd User PlugLoaded

"-----------------------
"  Colors
"-----------------------

set termguicolors
set background=dark

"-----------------------------
"  Language Server Config
"-----------------------------

source $XDG_CONFIG_HOME/nvim/nvim-cmp-postconfig.lua

"-----------------------------
"  Keybindingss
"-----------------------------

let mapleader=" "

map <leader>ve :edit $XDG_CONFIG_HOME/nvim/init.vim<CR>
map <leader>vr :source $XDG_CONFIG_HOME/nvim/init.vim<CR>
map <leader>h  :noh<CR>

" Reselect after indent
vnoremap < <gv
vnoremap > >gv

" Faster buffer switching
nnoremap gb         :buffers<CR>:buffer<Space>
nnoremap <PageUp>   :bprevious<CR>
nnoremap <PageDown> :bnext<CR>

" Save my fingers
map ī k
map s j
map ē h
map ā l

" Edit file under cursor
map gf :edit <cfile><CR>

" Language server bindings
nnoremap <silent> gd <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> gD <cmd>lua vim.lsp.buf.declaration()<CR>
nnoremap <silent> gr <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> gi <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> K <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> <C-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> <C-n> <cmd>lua vim.lsp.buf.goto_prev()<CR>
nnoremap <silent> <C-p> <cmd>lua vim.lsp.buf.goto_next()<CR>

nmap <silent> <leader>tr :Fern . -drawer -toggle<CR>
nmap <silent> <leader>tt :Fern . -reveal=% -drawer -toggle<CR>

"-----------------------------
"  Custom commands
"-----------------------------

command! W :execute ':silent w !sudo tee % > /dev/null' | :edit!
