#!/bin/sh

# user input
read -p "Enter email for git: " git_email

#--------------------------------------------------------------------------------
# vim
#--------------------------------------------------------------------------------

# pathogen
echo -n installing pathogen...
mkdir -p ~/.vim
mkdir -p ~/.vim/autoload
mkdir -p ~/.vim/bundle
curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
echo " done"

# vim-sensible
echo -n installing vim-sensible...
rm -rf ~/.vim/bundle/vim-sensible
git clone -q https://github.com/tpope/vim-sensible.git ~/.vim/bundle/vim-sensible
echo " done"

# vim-javascript
echo -n installing vim-javascript...
rm -rf ~/.vim/bundle/vim-javascript
git clone -q https://github.com/pangloss/vim-javascript.git ~/.vim/bundle/vim-javascript
echo " done"

# vim-jsx
echo -n installing vim-jsx...
rm -rf ~/.vim/bundle/vim-jsx
git clone -q https://github.com/mxw/vim-jsx.git ~/.vim/bundle/vim-jsx
echo " done"

cp .vimrc ~/.vimrc


#--------------------------------------------------------------------------------
# other
#--------------------------------------------------------------------------------

cp .gitconfig ~/.gitconfig
echo "\temail = $git_email" >> ~/.gitconfig
