#!/usr/bin/env bash

PACKAGES=(zsh git tmux) # Packages to be installed.
FILES=(.tmux.conf .gitconfig .vim .zsh .zsh_aliases .zsh_functions .zshrc) # Files to symlink into home directory.

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

# Install all package within $PACKAGES.
echo "Installing required packages. These consist of the following packages: (${PACKAGES[@]})"
for package in "${PACKAGES[@]}";
do
    sudo apt-get -y install $package
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
    if [ -L "$HOME/$file" ] ; then
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
