#!/usr/bin/env bash

PACKAGES=(zsh git tmux nvm fzf nvim) # Packages to be installed.
SYMLINK_DIRECTORIES=(git nvim zsh) # Files to symlink into home directory.

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
link_file() {
    local source=$1
    local destination=$2
    if [ -f "$destination" ] || [ -d "$destination" ] || [ -L "$destination" ]
    then
        local currentSource="$(readlink $destination)"
	if [ "$source" == "$currentSource" ]
	then
	    return
        elif [ $BACKUP = true ]
        then
            mv "$destination" "$BACKUP_DIR"
            echo "$destination backed up into $BACKUP_DIR" | tee "$LOG_FILE"
        else
            rm -rf "$destination"
            echo "$destination removed" | tee "$LOG_FILE"
	fi
    fi
    ln -s "$source" "$destination" 
    echo "$source linked to $destination" | tee "$LOG_FILE"

}
if [ $BACKUP = true ] ; then
    mkdir "$BACKUP_DIR"
fi

find -H "$DIRECTORY" -maxdepth 2 -name "links.prop" -not -path "*.git" | while read linkPropertyFile
do
    cat "$linkPropertyFile" | while read line
    do
        source=$(echo "$line" | cut -d '=' -f 1)
        destination=$(echo "$line" | cut -d '=' -f 2)
	mkdir -p "$(dirname $HOME/$destination)"
	link_file "$DIRECTORY/$source" "$HOME/$destination"
    done
done
