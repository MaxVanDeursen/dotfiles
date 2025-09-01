# Include aliases and functions
source ~/.zsh_aliases
source ~/.zsh_functions

export PATH=/opt/homebrew/opt/openjdk/bin:/home/max/.local/bin:$PATH
# Prompt
prompt_git () {
    BRANCH="$(git branch --show-current 2> /dev/null)"
    if [ -n "$BRANCH" ] ; then
        BRANCH="%F{red}-[%F{white}$BRANCH%F{red}]%f%k"
    fi
    echo $BRANCH
}
USER='%F{red}[%F{white}%n%F{red}@%F{white}%m%F{red}]%f%k'
GIT='$(prompt_git)'
TIME='%F{red}[%F{white}%*%F{red}]%f%k'
DIR='%F{red}[%F{white}%(2~|.../%1~|%~)%F{red}]%f%k'
PS1="$USER%F{red}-$DIR$GIT%F{red}->%f%k "

# Vim bindings
bindkey -v

###############
# ZSH Options #
###############

# Allow for the prompt string to be substituted.
setopt PROMPT_SUBST

# Automatically CD into directory if not found as command
setopt AUTO_CD

# Please, just do not beep
unsetopt LIST_BEEP
unsetopt BEEP
unsetopt HIST_BEEP

# Complete at the first match when there are ambiguous definitions
setopt MENU_COMPLETE

# Make pattern matching and globbing case insensitive.
unsetopt CASE_GLOB
unsetopt CASE_MATCH

# Share history across sessions
setopt SHARE_HISTORY

# Increment history after command execution
setopt INC_APPEND_HISTORY

HISTFILE=$HOME/.zsh_history
HISTSIZE=100000000
SAVEHIST=100000000

export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
