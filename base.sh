#!/bin/sh
# Lays down a basic config for hacking on, for example, remote systems.
# Not a full development setup.

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
cp vim/.vimrc ~/.vimrc
printf 'done\n'


#--------------------------------------------------------------------------------
# git
#--------------------------------------------------------------------------------

printf 'Configuring git... '
mkdir -p ~/.config/git
cp git/.gitconfig ~/.config/git/config
git config --global --add user.name "$FULL_NAME"
git config --global --add user.email "$EMAIL"
printf 'done\n'


#--------------------------------------------------------------------------------
# tmux
#--------------------------------------------------------------------------------

printf 'Configuring tmux... '
cp tmux/.tmux.conf ~/.tmux.conf
printf 'done\n'


#--------------------------------------------------------------------------------
# bash
#--------------------------------------------------------------------------------

printf 'Configuring bash... '
wget -q https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash -O ~/.git-completion.bash
cp bash/.bashrc ~/.bashrc
printf 'done\n'
