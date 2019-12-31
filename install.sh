#!/bin/sh

if [ -z "$1" ] || [ -z "$2" ]; then
  echo 'Usage: ./install.sh <full_name> <email>'
  exit
else
  GIT_NAME="$1"
  GIT_EMAIL="$2"
fi


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
" other settings will mess with crontab -e
set backupcopy=yes

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


#--------------------------------------------------------------------------------
# bash
#--------------------------------------------------------------------------------



cat << 'EOF' > ~/.bashrc
umask 022
cd ~

# the bash history should save 3000 commands
export HISTFILESIZE=3000
# don't put duplicate lines in the history
export HISTCONTROL=ignoredups
# append to the history file, don't overwrite it
shopt -s histappend

export LS_COLORS='rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=01;05;37;41:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:'

export PS1='\[\e]0;\w\a\]\[\e[36m\]\u@\h \[\e[33m\][\w]\[\e[0m\]\$ '
export EDITOR=vim
# makes sure that highlighting works in vim when in tmux session
export TERM=xterm-256color
export PATH=/sbin:/usr/sbin:/bin:/usr/bin:/usr/local/bin:/usr/local/sbin:/opt:~/bin:~/.local/bin:.
# not sure if this is needed
#export MANPATH=/usr/man:/usr/bin/man:/usr/local/man:$MANPATH:.

alias ls='ls --color'

h() (
  if [ -n "$1" ]; then
    history | grep "$1"
  else
    history | tail -n 30
  fi
)

dsh() (
  if [ -z "$1" ]; then
    printf "usage: dsh <container_name>\n"
    exit 1
  fi
  if [ -n "$SSH_AUTH_SOCK" ]; then
    docker exec -it --env SSH_AUTH_SOCK=${SSH_AUTH_SOCK} $1 /bin/bash ||
    docker exec -it --env SSH_AUTH_SOCK=${SSH_AUTH_SOCK} $1 /bin/sh ||
    printf "Container $1 does not exist\n"
  else
    docker exec -it $1 /bin/bash ||
    docker exec -it $1 /bin/sh ||
    printf "Container $1 does not exist\n"
  fi
)

dkill() (
  if [ -n "$1" ]; then
    docker container stop $1 && docker container rm $1
  else
    printf "usage: dkill <container_name>\n"
  fi
)
EOF
