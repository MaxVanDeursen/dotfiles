# Include aliases and functions
source ~/.zsh_aliases
source ~/.zsh_functions

export PATH=/opt/homebrew/opt/openjdk/bin:$HOME/.local/bin:$PATH
export EDITOR=nvim
export VISUAL=nvim
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

# Share history across sessions (implies incremental append)
setopt SHARE_HISTORY

HISTFILE=$HOME/.zsh_history
HISTSIZE=100000000
SAVEHIST=100000000

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# fzf keybindings (Ctrl+R history, Ctrl+T file picker, Alt+C cd)
[ -f "$(brew --prefix)/opt/fzf/shell/key-bindings.zsh" ] && source "$(brew --prefix)/opt/fzf/shell/key-bindings.zsh"
[ -f "$(brew --prefix)/opt/fzf/shell/completion.zsh" ] && source "$(brew --prefix)/opt/fzf/shell/completion.zsh"
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow'
