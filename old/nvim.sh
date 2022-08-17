#!/bin/sh

USAGE=$(cat << EOF
Usage: ./nvim.sh
EOF
)


# install dependencies
printf 'Installing dependencies...\n'

# vim-plug
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

printf 'Done installing dependencies.\n'


# write init.vim
printf 'Configuring nvim... '
cp ./init.vim ~/.config/nvim/init.vim
printf 'done\n'
