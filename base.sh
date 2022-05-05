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

cat << EOF > ~/.gitconfig
[core]
  editor = vim
[alias]
  a = add
  b = branch
  c = checkout
  d = diff
  f = fetch
  s = status
  do = log --decorate --oneline
  adog = log --all --decorate --oneline --graph
  adogs = log --all --decorate --oneline --graph --simplify-by-decoration
[push]
  default = current
[pull]
  ff = only
[color]
  ui = auto
[user]
  name = $FULL_NAME
  email = $EMAIL
EOF

printf 'done\n'


#--------------------------------------------------------------------------------
# tmux
#--------------------------------------------------------------------------------

printf 'Configuring tmux... '

cat << EOF > ~/.tmux.conf
set-option -g mode-keys vi
bind-key -T copy-mode-vi 'v' send -X begin-selection
bind-key -T copy-mode-vi 'y' send -X copy-selection
bind-key -T copy-mode-vi 'Y' send -X copy-line
bind-key -n F1 select-pane -t 0
bind-key -n F2 select-pane -t 1
bind-key -n F3 select-pane -t 2
bind-key -n F4 select-pane -t 3
bind-key -n F5 select-pane -t 4

set-option -g default-command '/usr/bin/env bash'
set-option -g escape-time 0
EOF

printf 'done\n'


#--------------------------------------------------------------------------------
# bash
#--------------------------------------------------------------------------------

printf 'Configuring bash... '

wget -q https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash -O ~/.git-completion.bash

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
export PATH=/sbin:/usr/sbin:/bin:/usr/bin:/usr/local/bin:/usr/local/sbin:/opt:~/bin:~/.local/bin:/usr/local/go/bin:.
# golang-specific stuff
export GOPATH=~/.go
export GOBIN=~/.local/bin
# completion for git branch paths (and probably other things)
. ~/.git-completion.bash

alias ls='ls --color=auto'


h() (
	if [ -n "$1" ]; then
		history | grep "$1"
	else
		history | tail -n 30
	fi
)


dsh() (
	if [ -z "$1" ]; then
		printf "usage: dsh <container_name> [shell_name]\n"
		exit 1
	fi
	if ! docker container inspect "$1" 2>&1 1>& /dev/null; then
		printf "dsh: container %s does not exist\n" "$1"
	fi
	if [ -n "$2" ]; then
		USE_SHELL="$2"
	else
		USE_SHELL='bash'
	fi
	if [ -n "$SSH_AUTH_SOCK" ]; then
		docker exec -it --env SSH_AUTH_SOCK=${SSH_AUTH_SOCK} "$1" /usr/bin/env "$USE_SHELL"
	else
		docker exec -it "$1" /usr/bin/env "$USE_SHELL"
	fi
)


dkill() (
	if [ -n "$1" ]; then
		docker container stop $1 && docker container rm $1
	else
		printf "usage: dkill <container_name>\n"
	fi
)


activate() {
	if [ -d ./local.venv ]; then
		. local.venv/bin/activate
	elif ! [ -d ./venv ]; then
		printf 'Creating a new venv at ./venv\n'
		python3 -m venv venv
		. venv/bin/activate
	else
		. venv/bin/activate
	fi
}


dev() {
	if [ -z "$1" ]; then
		printf 'usage: dev <path>\n'
		return
	fi

	if ! tmux has-session -t "$1" >> /dev/null 2>&1; then
		# create tmux session if it doesn't already exist
		tmux new-session -s "$1" -d

		# build two panes in it if they don't already exist
		NUMBER_OF_PANES="$(tmux list-panes -t "$1" | wc -l)"
		if [ "$NUMBER_OF_PANES" -eq '1' ]; then
			tmux split-window -h -t "$1" -c "$1"
			if [ -d "$1" ]; then
				tmux send-keys -t "$1:0.0" "cd $1" ENTER clear ENTER
				tmux send-keys -t "$1:0.1" "cd $1" ENTER clear ENTER
			fi
		fi

		# activate virtualenvs if there are certain filenames in the directories
		if [ -f "$1/setup.py" ]; then
			tmux send-keys -t "$1:0.0" activate ENTER
			tmux send-keys -t "$1:0.1" activate ENTER
		fi
	fi

	# attach to session
	tmux attach-session -t "$1"
}

goh() {
	go help $1 | less -FX
}

god() {
	go doc $1 | less -FX
}

EOF

printf 'done\n'
