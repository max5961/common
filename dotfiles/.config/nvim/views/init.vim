call plug#begin('~/.local/share/nvim/plugged')

Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.2' }
Plug 'morhetz/gruvbox'
Plug 'jiangmiao/auto-pairs'
Plug 'Yggdroot/indentLine'
Plug 'pangloss/vim-javascript'
Plug 'preservim/nerdtree'
Plug 'voldikss/vim-floaterm'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'mattn/emmet-vim'
Plug 'mattn/webapi-vim'
Plug 'PhilRunninger/nerdtree-visual-selection'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'

call plug#end()

let mapleader = " "

" telescope
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

" nerdtree
" NERDTreeToggle % opens the NERDTreee in the current working dir
nnoremap <leader>nerd <cmd>NERDTreeToggle %<cr>
" nerh: short for nerd - home
nnoremap <leader>nerh <cmd>NERDTree ~/<cr>
nnoremap <leader>h <C-w>w
let g:NERDTreeShowHidden=1

" Yggdroot/indentLine
let g:indentLine_char = '|'
" indentLine conceals quotations in JSON by default
let g:vim_json_conceal=0
let g:markdown_syntax_conceal=0

" map escape to exit terminal mode
:tnoremap <Esc> <C-\><C-n>
" floaterm - floating terminal window
nnoremap <leader>nterm <cmd>FloatermNew<cr>
" FloatermNew is not needed to initialize a new terminal if none exist.
" FloatermToggle will initialize a new terminal if none exist as well as toggle terminal view.
nnoremap <leader>t <cmd>FloatermToggle<cr>
nnoremap <leader>kt <cmd>FloatermKill<cr>
nnoremap <leader>tn <cmd>FloatermNext<cr>
nnoremap <leader>tp <cmd>FloatermPrev<cr>

" toggle between files
nnoremap <leader>j <cmd>bnext<cr>
nnoremap <leader>k <cmd>bprev<cr>

" yank to copy into default clipboard
set clipboard+=unnamedplus

set mouse=
set tabstop=4
set shiftwidth=4
set expandtab
set smartindent

" disable linewrap
" set nowrap
set textwidth=0
" disable backspace deleting into the above/below lines
set backspace=indent,start
" always have at least 12 lines above/below when scrolling through the middle of a document
set scrolloff=12

set nohlsearch

" always block cursor 
set guicursor=""
set number
set relativenumber

set nobackup
set nowritebackup
set noswapfile

" fold blocks of code
syntax enable
set foldmethod=syntax
set foldlevelstart=99
set viewdir=~/.config/nvim/views
autocmd BufWrite * silent! mkview!
autocmd BufRead * silent! loadview

" colors
" in line 94 of .local/share/nvim/plugged/gruvbox/gruvbox/colors/gruvbox.vim
" dark2 color changed from #504945 to #9e948e
" the original dark2 color was too close to the background color making it
" very hard to read text
colorscheme gruvbox
set termguicolors
hi Normal guibg=NONE ctermbg=NONE
hi NormalNC guibg=NONE ctermbg=NONE

" autocomplete
inoremap <silent><expr> <M-j> coc#pum#visible() ? coc#pum#next(0) : "\<M-j>"
inoremap <silent><expr> <M-k> coc#pum#visible() ? coc#pum#prev(0) : "\<M-k>"
inoremap <silent><expr> <Tab> coc#pum#visible() ? coc#pum#confirm() : "\<Tab>"

let g:user_emmet_settings = webapi#json#decode(join(readfile(expand('~/.config/nvim/emmet-snippets/snippets.json')), "\n"))


