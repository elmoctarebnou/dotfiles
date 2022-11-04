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
set nohlsearch!
set updatetime=100 " Remove lag for vim-gitgutter

" ========= Install Plugins ==========
call plug#begin('~/.vim/plugged')

Plug 'gruvbox-community/gruvbox' " Color theme
Plug 'lukas-reineke/indent-blankline.nvim' " Indent
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
    \'coc-eslint',
    \'coc-pyright',
\] "list of CoC extensions needed
Plug 'yuezk/vim-js' " JS syntax highlighting
Plug 'maxmellon/vim-jsx-pretty' " JSX syntax highlighting
Plug 'chr4/nginx.vim' " Syntax highlighting for nginx
Plug 'vim-scripts/indentpython.vim' " Auto indentation for python
" ]]
" Icons settings. Note set compatible font in terminal like Hack Nerd [[
Plug 'ryanoasis/vim-devicons'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
" ]]
" Install then load plugin only for editing supported files
Plug 'prettier/vim-prettier', { 'do': 'yarn install --frozen-lockfile --production' }
Plug 'frazrepo/vim-rainbow' " Bracket color
Plug 'scrooloose/nerdtree' " File navigation
Plug 'scrooloose/nerdcommenter' " Code comment
Plug 'easymotion/vim-easymotion' " Search text in file
Plug 'tpope/vim-fugitive' " Let you run git commands from vim
Plug 'christoomey/vim-tmux-navigator' " Navigation between tmux and vim
Plug 'airblade/vim-gitgutter' " Display line changed in file
" Telescope file search required plugins [[
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzy-native.nvim'
" Python cell execution [[
Plug 'benmills/vimux'
Plug 'greghor/vim-pyShell'
let g:cellmode_default_mappings='0'
Plug 'julienr/vim-cellmode'
" Vim ipython
Plug 'jpalardy/vim-slime', { 'for': 'python' }
Plug 'hanschen/vim-ipython-cell', { 'for': 'python' }
" ]]
call plug#end()

" =============== Key binding ==============
let mapleader = " " " Leader settings
nnoremap <leader>sw :lua require('telescope.builtin').grep_string({ search = vim.fn.input("Grep For > ")})<CR>
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
" Map prettier command
nnoremap <leader>p :Prettier<cr>
" Toggle search highlighting
nnoremap <leader>h :set hlsearch!<cr>
" Map block fast movement [[
nnoremap t <C-u>
nnoremap b <C-d>
"]]
" ipython cell running with vim-slime [[
let g:slime_target = "tmux"
let g:slime_default_config = {"socket_name": "default", "target_pane": "{last}"}
nnoremap <Leader>ss :SlimeSend1 ipython<CR>
nnoremap <Leader>sr :IPythonCellRestart<CR>
nnoremap <Leader>r :IPythonCellRun<CR>
nnoremap <Leader>sc :IPythonCellClear<CR>
"]]

"================= Pluggins configuration ================
colorscheme gruvbox
highlight Normal guibg=none
let $FZF_DEFAULT_COMMAND = 'ag -g ""'
let g:jsx_ext_required = 0 " Highlight jsx syntax even in non .jsx files vim-jsx
let g:deoplete#enable_at_startup = 1
let NERDTreeIgnore = ['\.pyc$']
let g:rainbow_active = 1
let python_highlight_all=1 " Python default syntax highlighting enable
syntax on
" Vim cell send settings [[
let g:vim_bootstrap_langs = "python"
let g:vim_bootstrap_editor = "nvim"
filetype plugin indent on " Required
let g:cellmode_use_tmux=1
let g:cellmode_tmux_panenumber=1
" ]]
