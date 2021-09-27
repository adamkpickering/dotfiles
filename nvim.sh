#!/bin/sh

USAGE=$(cat << EOF
Usage: ./nvim.sh
EOF
)

if test ! $(which nvim); then
	printf 'nvim is not installed, or is not on path.\n'
	printf 'Please install it before continuing.\n'
	exit 1
fi

printf 'Configuring nvim... '

# write nvim config
cat << EOF > ~/.config/nvim/init.vim
color elflord
set noexpandtab
set number
set scrolloff=999
set paste

" expandtab/noexpandtab -> whether entered tabs are turned into spaces
" shiftwidth -> how many columns text is indented with << and >>
" tabstop -> the number of spaces a tab is represented by
" softtabstop -> used for mixing tabs and spaces if softtabstop < tabstop
"       and expandtab is not set

autocmd FileType javascript.jsx setlocal shiftwidth=2 tabstop=2 noexpandtab
autocmd FileType json           setlocal shiftwidth=2 tabstop=2 noexpandtab
autocmd FileType yaml           setlocal shiftwidth=2 tabstop=2 expandtab
autocmd FileType markdown       setlocal shiftwidth=2 tabstop=2 expandtab
autocmd FileType html           setlocal shiftwidth=2 tabstop=2 noexpandtab
autocmd FileType htmldjango     setlocal shiftwidth=2 tabstop=2 noexpandtab
autocmd FileType tf             setlocal shiftwidth=2 tabstop=2 expandtab
autocmd FileType python         setlocal shiftwidth=4 tabstop=4 expandtab
autocmd FileType sh             setlocal shiftwidth=4 tabstop=4 noexpandtab
autocmd FileType css            setlocal shiftwidth=4 tabstop=4 noexpandtab
autocmd FileType sshconfig      setlocal shiftwidth=4 tabstop=4 noexpandtab
autocmd FileType go             setlocal shiftwidth=4 tabstop=4 noexpandtab

" markdown syntax is poorly defined so highlighting is a dumpster fire
autocmd FileType markdown setlocal syntax=off

" set indents after various conditions in python code to only one "tab"
let g:pyindent_open_paren = 'shiftwidth()'
let g:pyindent_nested_paren = 'shiftwidth()'
let g:pyindent_continue = 'shiftwidth()'

EOF

printf 'done\n'
