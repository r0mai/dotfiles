#!/bin/bash
############################
# .make.sh
# This script creates symlinks from the home directory to any desired dotfiles in ~/dotfiles
############################

########## Variables

set -e
set -x

dir=~/dotfiles # dotfiles directory
olddir=~/dotfiles_old # old dotfiles backup directory
# list of files/folders to symlink in homedir

# commented out when transitioning form bash to zsh
# files="bash_profile bashrc vimrc vim gitconfig gitignore_global ycm_extra_conf.py config/nvim/init.vim git-prompt-colors.sh"
files="zshrc vimrc vim gitconfig gitignore_global ycm_extra_conf.py"

##########

# create dotfiles_old in homedir
echo -n "Creating $olddir for backup of any existing dotfiles in ~ ..."
mkdir -p $olddir
echo "done"

# change to the dotfiles directory
echo -n "Changing to the $dir directory ..."
cd $dir
echo "done"

# move any existing dotfiles in homedir to dotfiles_old directory, then create symlinks from the homedir to any files in the ~/dotfiles directory specified in $files
echo "Moving any existing dotfiles from ~ to $olddir"
for file in $files; do
	if [ -f ~/.$file ]; then
		mv ~/.$file $olddir
	fi

	if [ -h ~/.$file ]; then
		echo "Skipping ~/.$file (already a symlink)"
	else
		echo "Creating symlink to $file in home directory."
		ln -s $dir/$file ~/.$file
	fi

done

mkdir -p ~/config/nvim/
ln -s $dir/config/nvim/init.vim ~/.config/nvim/init.vim
