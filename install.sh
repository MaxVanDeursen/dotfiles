#!/usr/bin/env bash

PACKAGES=(zsh git tmux) # Packages to be installed.
FILES=(.gitconfig .vim .zsh .zsh_aliases .zsh_functions .zshrc) # Files to symlink into home directory.

DIRECTORY=$(dirname $(realpath $BASH_SOURCE)) # Directory in which this file resides.
LOG_FILE=dotfile_installation.log # Filename of the log created during execution.
BACKUP=false # Whether old files in home directory with FILES should be backed up or not.
BACKUP_DIR="dotfile-backup $(date)"
while getopts "l:b" opt; do
    case $opt in
        l) LOG_FILE="$OPTARG" ;;
        b) BACKUP=true ;;
        \?) echo "Unknown argument"
    esac
done

echo "This script requires ROOT permissions to install packages"

PACKAGE_MANAGER="brew"
if command -v apt-get 2>&1 >/dev/null
then
    # Use apt-get as package manager.
    PACKAGE_MANAGER="apt-get -y"
elif ! command -v brew 2>&1 >/dev/null
then
    # Download "brew" and use it.
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Install all package within $PACKAGES.
echo "Installing required packages. These consist of the following packages: (${PACKAGES[@]})"
for package in "${PACKAGES[@]}";
do
    eval $PACKAGE_MANAGER install $package
    if type -p zsh > /dev/null; then
        echo "$package installed" | tee "$LOG_FILE"
    else
        echo "$package failed to install... Quitting"
        exit 1
    fi
done

# Symlink dotfiles, making backups if set.
if [ $BACKUP = true ] ; then
    mkdir "$BACKUP_DIR"
fi
for file in "${FILES[@]}"; do
    if [ -e "$HOME/$file" ] ; then
        if [ $BACKUP = true ]; then
            mv "$HOME/$file" "$BACKUP_DIR"
            echo "$HOME/$file backed up into $BACKUP_DIR" | tee "$LOG_FILE"
        else
            rm "$HOME/$file"
            echo "$HOME/$file removed" | tee "$LOG_FILE"
        fi
    fi
    ln -s "$DIRECTORY/$file" "$HOME/$file" 
    echo "$DIRECTORY/$file linked to $HOME/$file" | tee "$LOG_FILE"
done

if [ -e "$HOME/.config/nvim" ] ; then
    if [ $BACKUP = true ] ; then
        mv "$HOME/.config/nvim" "$BACKUP_DIR"
        echo "$HOME/$file backed up into $BACKUP_DIR" | tee "$LOG_FILE"
    else
        rm -r "$HOME/.config/nvim"
        echo "$HOME/.config/nvim removed" | tee "$LOG_FILE"
    fi
fi
mkdir -p $HOME/.config
ln -s "$DIRECTORY/nvim" "$HOME/.config/nvim"
echo "$DIRECTORY/nvim linked to $HOME/.config/nvim" | tee "$LOG_FILE"

chsh -s $(which zsh)
