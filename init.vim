" ========= General settings ==========
syntax enable
set directory=$HOME/.vim/swap//
set exrc
set relativenumber
set nu
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
set updatetime=100 " Remove lag for vim-gitgutter

" ========= Install Plugins ==========
call plug#begin('~/.vim/plugged')
Plug 'gruvbox-community/gruvbox' " Color theme
" Syntax highlighting configuration [[
Plug 'ntpeters/vim-better-whitespace' " Trailing whitespace automatic fixing
Plug 'neoclide/coc.nvim', {'branch': 'release'}
let g:coc_global_extensions = [
    \'coc-emmet',
    \'coc-tsserver',
    \'coc-css',
    \'coc-html',
    \'coc-json',
    \'coc-sql',
    \'coc-docker',
\] "list of CoC extensions needed
Plug 'yuezk/vim-js' " JS syntax highlighting
Plug 'maxmellon/vim-jsx-pretty' " JSX syntax highlighting
Plug 'chr4/nginx.vim' " Syntax highlighting for nginx
" ]]
" Icons settings. Note set compatible font in terminal like Hack Nerd [[
Plug 'ryanoasis/vim-devicons'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
" ]]
Plug 'frazrepo/vim-rainbow' " Brack color
Plug 'scrooloose/nerdtree' " File navigation
Plug 'scrooloose/nerdcommenter' " Code comment
Plug 'easymotion/vim-easymotion' " Search text in file
Plug 'tpope/vim-fugitive' " Let you run git commands
Plug 'christoomey/vim-tmux-navigator' " Navigation between tmux and vim
Plug 'airblade/vim-gitgutter' " Display line changed in file
call plug#end()

" =============== Key binding ==============
let mapleader = " " " Leader settings
nnoremap <leader>s :lua require('telescope.builtin').grep_string({ search = vim.fn.input("Grep For > ")})<CR>
nnoremap <leader>ff <cmd>Telescope find_files<cr>
" Nerdtree settings [[
nnoremap <leader>ft :NERDTreeToggle<CR>
" ]]
" Commenting settings [[
vmap <leader>cc <plug>NERDCommenterToggle
vmap <leader>ci <plug>NERDCommenterInvert
" ]]
nnoremap <leader>vs <cmd>vsplit<cr>
nnoremap <leader>hs <cmd>split<cr>
imap jj <Esc>
nmap <silent>gd <Plug>(coc-definition)
vmap <leader>fs  <Plug>(coc-format-selected)-

"================= Pluggins configuration ================
colorscheme gruvbox
highlight Normal guibg=none
let $FZF_DEFAULT_COMMAND = 'ag -g ""'
let g:jsx_ext_required = 0 " Highlight jsx syntax even in non .jsx files vim-jsx
let g:deoplete#enable_at_startup = 1
let NERDTreeIgnore = ['\.pyc$']
let g:rainbow_active = 1
