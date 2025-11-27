#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Aliases
alias ls='ls --color=auto'
alias grep='grep --color=auto'

# Monokai Pro inspired prompt
PS1='\[\033[38;2;255;97;136m\]\u\[\033[0m\]@\[\033[38;2;120;220;232m\]\h\[\033[0m\] \[\033[38;2;255;216;102m\]\w\[\033[0m\] \[\033[38;2;169;220;118m\]❯\[\033[0m\] '

# Enable 256 color support
export TERM=xterm-256color

# LS_COLORS for Monokai Pro theme
export LS_COLORS='di=38;2;120;220;232:fi=38;2;252;252;250:ln=38;2;255;97;136:ex=38;2;255;216;102'

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export PATH="$HOME/.local/bin:$PATH"

