#!/usr/bin/env bash

PACKAGES=(zsh git tmux fzf gettext cmake curl ripgrep luarocks python3) # Packages to be installed.
APT_PACKAGES=("${PACKAGES[@]}" ninja-build build-essential fd-find)
BREW_PACKAGES=("${PACKAGES[@]}" ninja fd opencode)

SYMLINK_DIRECTORIES=(git nvim zsh tmux) # Files to symlink into home directory.

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

SUDO=""
[ "$(id -u)" -ne 0 ] && SUDO="sudo"

INSTALL_PACKAGES=(${BREW_PACKAGES[@]})
PACKAGE_MANAGER="brew"
if command -v apt-get >/dev/null 2>&1
then
    # Use apt-get as package manager.
    PACKAGE_MANAGER="apt-get -y"
    INSTALL_PACKAGES=(${APT_PACKAGES[@]})
elif ! command -v brew >/dev/null 2>&1
then
    # Download "brew" and use it.
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Install NVM
export NVM_DIR="$HOME/.nvm"
if [ ! -d "$NVM_DIR" ]; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
fi
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
nvm install --lts
nvm use --lts
npm install -g @anthropic-ai/claude-code

# Install all package within $PACKAGES.
echo "Installing required packages. These consist of the following packages: (${INSTALL_PACKAGES[@]})"
for package in "${INSTALL_PACKAGES[@]}";
do
    if eval $PACKAGE_MANAGER install $package; then
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

# Build and install Neovim.
if [ ! -d "$DIRECTORY/neovim" ]; then
    git clone --depth 1 https://github.com/neovim/neovim "$DIRECTORY/neovim"
fi
cd "$DIRECTORY/neovim"
git pull
rm -rf build/
make CMAKE_BUILD_TYPE=RelWithDebInfo
$SUDO make install
