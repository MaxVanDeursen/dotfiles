###############
# ZSH Options #
###############

# Automatically CD into directory if not found as command
setopt AUTO_CD

# Please, just do not beep
unsetopt LIST_BEEP
unsetopt BEEP
unsetopt HIST_BEEP

# Complete at the first match when there are ambiguous definitions
setopt MENU_COMPLETE

# Always use floats, which removes integer division.
setopt FORCE_FLOAT

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
