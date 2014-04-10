[ -z "$PS1" ] && return

function parse_git_dirty {
  git diff --no-ext-diff --quiet --exit-code &> /dev/null || echo "*"
}

function parse_git_branch {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/ (\1$(parse_git_dirty))/"
}

function prompt {
  local CLEAR="\[\033[00m\]"

  local BLACK="\[\033[0;30m\]"
  local RED="\[\033[0;31m\]"
  local GREEN="\[\033[0;32m\]"
  local YELLOW="\[\033[0;33m\]"
  local BLUE="\[\033[0;34m\]"
  local PURPLE="\[\033[0;35m\]"
  local CYAN="\[\033[0;36m\]"
  local WHITE="\[\033[0;37m\]"

  local BLACKBOLD="\[\033[1;30m\]"
  local REDBOLD="\[\033[1;31m\]"
  local GREENBOLD="\[\033[1;32m\]"
  local YELLOWBOLD="\[\033[1;33m\]"
  local BLUEBOLD="\[\033[1;34m\]"
  local PURPLEBOLD="\[\033[1;35m\]"
  local CYANBOLD="\[\033[1;36m\]"
  local WHITEBOLD="\[\033[1;37m\]"
  export PS1="$CYANBOLD\u$CLEAR at $REDBOLD\h$CLEAR in $YELLOWBOLD\w$CLEAR$GREENBOLD\$(parse_git_branch)$CLEAR "
}

export CLICOLOR=1
export EDITOR='vim -f'
export LSCOLORS=dxgxhxdxbxegedabagacad

prompt

alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

PATH=/usr/local/bin:$PATH # Add homebrew path
PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting

# Add for Heroku Toolbelt and adb path
export PATH="/usr/local/heroku/bin:/Applications/Android Studio.app/sdk/platform-tools:/Applications/Android Studio.app/sdk/tools:$PATH"
