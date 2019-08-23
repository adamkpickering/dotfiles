#!/bin/sh


#--------------------------------------------------------------------------------
# vim
#--------------------------------------------------------------------------------

# pathogen
echo -n 'installing pathogen...'
mkdir -p ~/.vim
mkdir -p ~/.vim/autoload
mkdir -p ~/.vim/bundle
curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
echo " done"

# vim-sensible
echo -n 'installing vim-sensible...'
rm -rf ~/.vim/bundle/vim-sensible
git clone -q https://github.com/tpope/vim-sensible.git ~/.vim/bundle/vim-sensible
echo " done"

# vim-javascript
echo -n 'installing vim-javascript...'
rm -rf ~/.vim/bundle/vim-javascript
git clone -q https://github.com/pangloss/vim-javascript.git ~/.vim/bundle/vim-javascript
echo " done"

# vim-jsx
echo -n 'installing vim-jsx...'
rm -rf ~/.vim/bundle/vim-jsx
git clone -q https://github.com/mxw/vim-jsx.git ~/.vim/bundle/vim-jsx
echo " done"

cat << EOF > ~/.vimrc
syntax on
color elflord
set expandtab
set number
set scrolloff=999

autocmd FileType javascript.jsx setlocal shiftwidth=2 tabstop=2
autocmd FileType json           setlocal shiftwidth=2 tabstop=2
autocmd FileType yaml           setlocal shiftwidth=2 tabstop=2
autocmd FileType markdown       setlocal shiftwidth=2 tabstop=2
autocmd FileType html           setlocal shiftwidth=2 tabstop=2
autocmd FileType htmldjango     setlocal shiftwidth=2 tabstop=2
autocmd FileType python         setlocal shiftwidth=4 tabstop=4
autocmd FileType sh             setlocal shiftwidth=4 tabstop=4

execute pathogen#infect()
filetype plugin indent on
EOF


#--------------------------------------------------------------------------------
# git
#--------------------------------------------------------------------------------

read -p "Enter full name for git: " GIT_NAME
read -p "Enter email for git: " GIT_EMAIL
cat << EOF > ~/.gitconfig
[core]
  editor = vim
[alias]
  s = status
  d = diff
  a = add
  c = commit
  adog = log --all --decorate --oneline --graph
[push]
  default = current
[color]
  ui = auto
[user]
  name = $GIT_NAME
  email = $GIT_EMAIL
EOF


#--------------------------------------------------------------------------------
# tmux
#--------------------------------------------------------------------------------

cat << EOF > ~/.tmux.conf
set-window-option -g mode-keys vi
EOF
#cp .tmux.conf ~/.tmux.conf
