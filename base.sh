#!/bin/sh

USAGE=$(cat << EOF
Usage: ./base.sh <full_name> <email> [OPTIONS]
EOF
)

if [ -z "$1" ] || [ -z "$2" ]; then
	printf '%s\n' "$USAGE"
	exit 1
else
	FULL_NAME="$1"
	EMAIL="$2"
fi


#--------------------------------------------------------------------------------
# vim
#--------------------------------------------------------------------------------

printf 'Configuring vim... '
cp ./.vimrc ~/.vimrc
printf 'done\n'


#--------------------------------------------------------------------------------
# git
#--------------------------------------------------------------------------------

printf 'Configuring git... '
cp .gitconfig ~/.gitconfig
cat << EOF >> ~/.gitconfig
[user]
  name = $FULL_NAME
  email = $EMAIL
EOF
printf 'done\n'


#--------------------------------------------------------------------------------
# tmux
#--------------------------------------------------------------------------------

printf 'Configuring tmux... '
cp .tmux.conf ~/.tmux.conf
printf 'done\n'


#--------------------------------------------------------------------------------
# bash
#--------------------------------------------------------------------------------

printf 'Configuring bash... '
wget -q https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash -O ~/.git-completion.bash
cp .bashrc ~/.bashrc
printf 'done\n'


#--------------------------------------------------------------------------------
# wezterm
#--------------------------------------------------------------------------------

printf 'Configuring wezterm... '
cp .wezterm.lua ~/.wezterm.lua
printf 'done\n'
