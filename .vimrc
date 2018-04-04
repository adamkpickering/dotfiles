syntax on
color elflord
set expandtab
set number
set scrolloff=999

autocmd FileType javascript.jsx setlocal shiftwidth=2 tabstop=2
autocmd FileType python setlocal shiftwidth=4 tabstop=4
autocmd FileType yaml setlocal shiftwidth=2 tabstop=2

execute pathogen#infect()
filetype plugin indent on
