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
