color default
set noexpandtab
set number
set scrolloff=999
set nohlsearch
set autoread
set noswapfile

" other settings will mess with crontab -e
set backupcopy=yes

" expandtab/noexpandtab -> whether entered tabs are turned into spaces
" shiftwidth -> how many columns text is indented with << and >>
" tabstop -> the number of spaces a tab is represented by
" softtabstop -> used for mixing tabs and spaces if softtabstop < tabstop
"       and expandtab is not set

autocmd FileType vim        setlocal shiftwidth=2 tabstop=2 expandtab
autocmd FileType javascript setlocal shiftwidth=2 tabstop=2 expandtab
autocmd FileType typescript setlocal shiftwidth=2 tabstop=2 expandtab
autocmd FileType jsx        setlocal shiftwidth=2 tabstop=2 expandtab
autocmd FileType vue        setlocal shiftwidth=2 tabstop=2 expandtab
autocmd FileType json       setlocal shiftwidth=2 tabstop=2 noexpandtab
autocmd FileType yaml       setlocal shiftwidth=2 tabstop=2 expandtab
autocmd FileType markdown   setlocal shiftwidth=2 tabstop=2 expandtab
autocmd FileType html       setlocal shiftwidth=2 tabstop=2 noexpandtab
autocmd FileType htmldjango setlocal shiftwidth=2 tabstop=2 noexpandtab
autocmd FileType tf         setlocal shiftwidth=2 tabstop=2 expandtab
autocmd FileType python     setlocal shiftwidth=4 tabstop=4 expandtab
autocmd FileType sh         setlocal shiftwidth=4 tabstop=4 noexpandtab
autocmd FileType css        setlocal shiftwidth=4 tabstop=4 noexpandtab
autocmd FileType sshconfig  setlocal shiftwidth=4 tabstop=4 noexpandtab
autocmd FileType go         setlocal shiftwidth=4 tabstop=4 noexpandtab

" markdown syntax is poorly defined so highlighting is a dumpster fire
autocmd FileType markdown setlocal syntax=off

" remove the highlighting on vertical divider
highlight VertSplit cterm=None

" general purpose window management mappings
nnoremap <C-h> :wincmd h<CR>
nnoremap <C-l> :wincmd l<CR>
tnoremap <C-h> <C-\><C-n>:wincmd h<CR>
tnoremap <C-l> <C-\><C-n>:wincmd l<CR>

" set indents after various conditions in python code to only one "tab"
let g:pyindent_open_paren = 'shiftwidth()'
let g:pyindent_nested_paren = 'shiftwidth()'
let g:pyindent_continue = 'shiftwidth()'

" auto-expand certain brackets
inoremap (<CR> (<CR>)<C-c>O
inoremap {<CR> {<CR>}<C-c>O
inoremap [<CR> [<CR>]<C-c>O

" <leader> mappings
let mapleader = " "
nnoremap <leader>q :q!<CR>
nnoremap <leader>w :w<CR>
nnoremap <leader>r :edit!<CR>

"===========================================================================
" plugin config
"===========================================================================

" ctrlp settings
let g:ctrlp_open_new_file = 'r'
let g:ctrlp_use_caching = 0
set wildignore+=*__pycache__*,submodules*,local.venv*,venv*
set wildignore+=vendor*
set wildignore+=node_modules*
"let g:ctrlp_extensions = ['fugitive-branches']

" COC.NVIM SETTINGS

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("nvim-0.5.0") || has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
function! s:check_back_space() abort
	let col = col('.') - 1
	return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" GoTo code navigation
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nmap <silent> <C-s> :<C-u>CocList -I symbols<CR>

" plugins
call plug#begin(stdpath('cache') . '/plugged')
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'ctrlpvim/ctrlp.vim'
Plug 'vim-scripts/argtextobj.vim'
"Plug 'adamkpickering/ctrlp-fugitive-branches'
call plug#end()


"===========================================================================
" tig stuff
"===========================================================================

nnoremap <leader>gs :call CloseAllWindowsButMain()<CR>:terminal tig status<CR>A
nnoremap <leader>gbl :call CloseAllWindowsButMain()<CR>:terminal tig blame -- %<CR>A
nnoremap <leader>gbr :call CloseAllWindowsButMain()<CR>:terminal tig refs<CR>A
nnoremap <leader>gp :!git pull<CR>
nnoremap <leader>gf :!git fetch --all<CR>
nnoremap <C-t> :call FocusTerminal()<CR>
tnoremap <C-t> <C-\><C-n>:call CloseAllWindowsButMain()<CR>
autocmd FileType gitcommit setlocal nonumber
autocmd FileType help :wincmd L
autocmd TermOpen * setlocal nonumber

function! FocusTerminal()
  call CloseAllWindowsButMain()
  wincmd n
  wincmd L
  for buf in getbufinfo()
    if getbufvar(buf.bufnr, 'ventana_buffer_name', '') ==# 'terminal'
      execute ':buffer ' .. buf.bufnr
      normal A
      return
    endif
  endfor
  terminal
  let b:ventana_buffer_name = 'terminal'
  normal A
endfunction

function! CloseAllWindowsButMain()
  execute '1wincmd w'
  for win in getwininfo()
    if win.winnr !=# 1
      execute 'close ' .. win.winnr
    endif
  endfor
endfunction
