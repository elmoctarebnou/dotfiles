syntax enable

syntax enable

set directory=$HOME/.vim/swap//
set exrc                   
set relativenumber
set nu
set nohlsearch
set hidden
set noerrorbells
set tabstop=4 softtabstop=4  
set shiftwidth=4
set expandtab
set smartindent
set nowrap 
set incsearch
set scrolloff=8
set colorcolumn=80
set signcolumn=yes
set encoding=UTF-8
  
call plug#begin('~/.vim/plugged') 
Plug 'neoclide/coc.nvim', {'branch': 'release'}
let g:coc_global_extensions = [
    \'coc-emmet', 
    \'coc-tsserver', 
    \'coc-css', 
    \'coc-html', 
    \'coc-json', 
    \'coc-prettier', 
    \'coc-snippets',
    \'coc-tslint-plugin', 
    \'coc-svg', 
    \'coc-sql', 
    \'coc-docker', 
    \'coc-pyright', 
    \'coc-powershell', 
\] "list of CoC extensions needed
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzy-native.nvim'
Plug 'gruvbox-community/gruvbox'
"{{ Configuring NerdTree
Plug 'scrooloose/nerdtree'
Plug 'scrooloose/nerdcommenter'
" ---> to hide unwanted files <---
let NERDTreeIgnore = [ '__pycache__', '\.pyc$', '\.o$', '\.swp',  '*\.swp',  'node_modules/' ]
" ---> show hidden files <---
let NERDTreeShowHidden=1
" ---> autostart nerd-tree when you start vim <---
autocmd vimenter * NERDTree
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:stdn_in") | NERDTree | endif
"}}

Plug 'vim-airline/vim-airline'
Plug 'tpope/vim-vinegar'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'mileszs/ack.vim'
Plug 'easymotion/vim-easymotion'
Plug 'ryanoasis/vim-devicons'
Plug 'tpope/vim-fugitive'
let $FZF_DEFAULT_COMMAND = 'ag -g ""'
Plug 'neoclide/coc.nvim', {'do': 'yarn install --frozen-lockfile'}
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'jiangmiao/auto-pairs'
Plug 'yuezk/vim-js'
Plug 'maxmellon/vim-jsx-pretty'
Plug 'pangloss/vim-javascript'
Plug 'leafgarland/typescript-vim'
Plug 'peitalin/vim-jsx-typescript'
Plug 'styled-components/vim-styled-components', { 'branch': 'main' }
Plug 'davidhalter/jedi-vim'
Plug 'zchee/deoplete-jedi'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
let g:deoplete#enable_at_startup = 1
call plug#end() 

colorscheme gruvbox
highlight Normal guibg=none

let mapleader = " "
nnoremap <leader>s :lua require('telescope.builtin').grep_string({ search = vim.fn.input("Grep For > ")})<CR>
nnoremap <leader>ff <cmd>Telescope find_files<cr>
" ---> toggling nerd-tree using Ctrl-N <---
nnoremap <leader>ft :NERDTreeToggle<CR>
nnoremap <leader>vs <cmd>vsplit<cr>
nnoremap <leader>hs <cmd>split<cr>
nnoremap <leader>h <c-w><c-h>
nnoremap <leader>j <c-w><c-j>
nnoremap <leader>k <c-w><c-k>
nnoremap <leader>l <c-w><c-l>

vmap <leader>cc <plug>NERDCommenterToggle

imap jj <Esc>

nmap <silent>gd <Plug>(coc-definition)
vmap <leader>fs  <Plug>(coc-format-selected)
