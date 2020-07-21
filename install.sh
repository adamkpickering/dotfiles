#!/bin/sh

if [ -z "$1" ] || [ -z "$2" ]; then
	echo 'Usage: ./install.sh <full_name> <email>'
	exit
else
	FULL_NAME="$1"
	EMAIL="$2"
fi


ask_if() (
	printf 'Want %s? (y/n): ' "$1"
	read CHOICE
	if [ "$CHOICE" = 'y' ]; then
		exit 0
	else
		exit 1
	fi
)


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

if ask_if 'javascript'; then
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
fi

cat << EOF > ~/.vimrc
syntax on
color elflord
set noexpandtab
set number
set scrolloff=999
" other settings will mess with crontab -e
set backupcopy=yes

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
autocmd FileType python         setlocal shiftwidth=4 tabstop=4 expandtab
autocmd FileType sh             setlocal shiftwidth=4 tabstop=4 noexpandtab
autocmd FileType css            setlocal shiftwidth=4 tabstop=4 noexpandtab
autocmd FileType sshconfig      setlocal shiftwidth=4 tabstop=4 noexpandtab
autocmd FileType go             setlocal shiftwidth=4 tabstop=4 noexpandtab

" markdown syntax is poorly defined so highlighting is a dumpster fire
autocmd FileType markdown setlocal syntax=off

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
[color]
  ui = auto
[user]
  name = $FULL_NAME
  email = $EMAIL
EOF


#--------------------------------------------------------------------------------
# tmux
#--------------------------------------------------------------------------------

cat << EOF > ~/.tmux.conf
set-option -g mode-keys vi
set-option -g default-command '/usr/bin/env bash'
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
export PATH=/sbin:/usr/sbin:/bin:/usr/bin:/usr/local/bin:/usr/local/sbin:/opt:~/bin:~/.local/bin:/usr/local/go/bin:.
# golang-specific stuff
export GOPATH=~/.go
export GOBIN=~/.local/bin
# not sure if this is needed
#export MANPATH=/usr/man:/usr/bin/man:/usr/local/man:$MANPATH:.

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
	if ! [ -d ./venv ]; then
		printf 'Creating a new venv at ./venv\n'
		python3 -m venv venv
	fi
	printf 'Activating venv at ./venv. Deactivate with `deactivate`\n'
	. venv/bin/activate
}
EOF


#--------------------------------------------------------------------------------
# mutt
#--------------------------------------------------------------------------------

if ask_if 'email'; then
	mkdir -p ~/.mutt/cache

	if ! which mutt; then
		printf 'warning: mutt is not installed\n'
	fi

	cat << EOF > ~/.muttrc
set realname = "${FULL_NAME}"
set from = "${EMAIL}"
set use_from = yes

set imap_user = "${EMAIL}"
set folder = "imaps://imap.gmail.com/"
set spoolfile = "+INBOX"
set postponed = "+[Gmail]/Drafts"

# gmail saves sent e-mail to +[Gmail]/Sent, so we don't want duplicates
unset record
set smtp_url = "smtps://$(printf ${EMAIL} | cut -d@ -f1)@smtp.gmail.com/"
set ssl_force_tls = yes

set header_cache =~/.mutt/cache/headers
set message_cachedir =~/.mutt/cache/bodies
set certificate_file =~/.mutt/certificates
set move = no
set imap_keepalive = 900

# sort emails in index first by thread, then by date, newest first
set sort = "threads"
set sort_aux = "reverse-date"

# don't mark unread messages that were previously seen but not read as 'O'
unset mark_old

# compose view options
set edit_headers
set forward_format = "Fwd: %s"
set include
set forward_quote
set editor = "vim"
# going to need to configure vim for this
#set text_flowed
# for when you want to turn mime messages into plain text when forwarding
#unset mime_forward
#set forward_decode

# key bindings
bind index j next-entry
bind index k previous-entry
bind index g first-entry
bind index G last-entry
bind index n search-next
bind index N search-opposite

bind pager j next-line
bind pager k previous-line
bind pager g top
bind pager G bottom
EOF
fi
