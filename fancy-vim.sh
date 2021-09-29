#!/bin/sh

USAGE=$(cat << EOF
Usage: ./fancy-vim.sh
EOF
)


# install dependencies
printf 'Installing dependencies...\n'

# vim-plug
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# YouCompleteMe
sudo apt install build-essential cmake vim-nox python3-dev
sudo apt install mono-complete golang nodejs default-jdk npm
printf 'Please follow steps at https://github.com/ycm-core/YouCompleteMe#linux-64-bit\n'
printf 'to finish YCM installation.\n'

# ctags
sudo apt install exuberant-ctags

printf 'Done installing dependencies.\n'


# write .vimrc
printf 'Configuring vim... '

cat << EOF > ~/.vimrc
syntax on
color elflord
set noexpandtab
set number
set scrolloff=999

" other settings will mess with crontab -e
set backupcopy=yes

" makes everything snappier when escaping from insert mode at the cost of
" not being able to use arrow keys in insert mode
set noesckeys

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

" auto-expand certain brackets
inoremap (<CR> (<CR>)<C-c>O
inoremap {<CR> {<CR>}<C-c>O
inoremap [<CR> [<CR>]<C-c>O

" <leader> mappings
let mapleader = " "
map <leader>q :q! <cr>
map <leader>w :w <cr>
map <leader>r :edit! <cr>

" tweak YouCompleteMe
set completeopt-=preview
let g:ycm_enable_diagnostic_signs = 0
let g:ycm_auto_hover = ''

" ctrlp settings
let g:ctrlp_open_new_file = 'r'
set wildignore+=*__pycache__*,submodules*,local.venv*,venv*
set wildignore+=vendor*

" plugins
call plug#begin('~/.vim/plugged')
Plug 'Valloric/YouCompleteMe'
Plug 'tpope/vim-surround'
Plug 'ctrlpvim/ctrlp.vim'
call plug#end()
EOF

printf 'done\n'
