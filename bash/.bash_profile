SSH_ENV="$HOME/.ssh/environment"
# `-z STRING` - True if string is empty
[ -z "$PS1" ] && return

# prompt colors
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
  export PS1="$CYANBOLD\u$CLEAR$BLACKBOLD at $CLEAR$YELLOWBOLD\h$CLEAR$BLACKBOLD in $CLEAR$GREENBOLD\w$CLEAR\$(parse_git_branch) "
}

# start the ssh-agent
function start_agent {
  echo "Initializing new SSH agent..."
  # spawn ssh-agent
  ssh-agent | sed 's/^echo/#echo/' > "$SSH_ENV"
  echo succeeded
  chmod 600 "$SSH_ENV"
  . "$SSH_ENV" > /dev/null
  ssh-add
}

# test for identities
function test_identities {
  # test whether standard identities have been added to the agent already
  ssh-add -l | grep "The agent has no identities" > /dev/null
  if [ $? -eq 0 ]; then
    ssh-add
    # $SSH_AUTH_SOCK broken so we start a new proper agent
    if [ $? -eq 2 ];then
      start_agent
    fi
  fi
}

function include {
  [[ -f "$1" ]] && source "$1"
}

# check for running ssh-agent with proper $SSH_AGENT_PID
if [ -n "$SSH_AGENT_PID" ]; then
  ps -ef | grep "$SSH_AGENT_PID" | grep ssh-agent > /dev/null
  if [ $? -eq 0 ]; then
    test_identities
  fi
  # if $SSH_AGENT_PID is not properly set, we might be able to load one from
  # $SSH_ENV
else
  if [ -f "$SSH_ENV" ]; then
    . "$SSH_ENV" > /dev/null
  fi
  ps -ef | grep "$SSH_AGENT_PID" | grep -v grep | grep ssh-agent > /dev/null
  if [ $? -eq 0 ]; then
    test_identities
  else
    start_agent
  fi
fi

# The color designators are as follows:
# a     black
# b     red
# c     green
# d     brown
# e     blue
# f     magenta
# g     cyan
# h     light grey
# A     bold black, usually shows up as dark grey
# B     bold red
# C     bold green
# D     bold brown, usually shows up as yellow
# E     bold blue
# F     bold magenta
# G     bold cyan
# H     bold light grey; looks like bright white
# x     default foreground or background
#
# The order of the attributes are as follows:
# 1.   directory
# 2.   symbolic link
# 3.   socket
# 4.   pipe
# 5.   executable
# 6.   block special
# 7.   character special
# 8.   executable with setuid bit set
# 9.   executable with setgid bit set
# 10.  directory writable to others, with sticky bit
# 11.  directory writable to others, without sticky bit
export CLICOLOR=1
export EDITOR='vim -f'
export LSCOLORS=dxgxhxdxbxegedabagacad

prompt

# aliases
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
if [ -f ~/.bash_aliases ]; then
  . ~/.bash_aliases
fi

export RAILS_ENV='development'

export ANDROID='/Applications/android-sdk-macosx'
export ANDROID_HOME='/Applications/android-sdk-macosx'
export ANDROID_VIEW_CLIENT_HOME='/usr/local/bin/AndroidViewClient'
export MAGICK_HOME='/usr/local/Cellar/imagemagick/6.7.7-6'
export DYLD_LIBRARY_PATH="$MAGICK_HOME/lib/"

export PATH=$ANDROID_HOME/platform-tools:$ANDROID_HOME/tools:/usr/local/maven/bin:/usr/local/mysql/bin:$HOME/.rvm/gems/ruby-1.9.3-p194/bin:$HOME/.rvm/gems/ruby-1.9.3-p194@global/bin:$HOME/.rvm/rubies/ruby-1.9.3-p194/bin:$HOME/.rvm/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/X11/bin:/usr/local/git/bin:/usr/X11/bin:${PATH}

# PATH=/Library/Frameworks/Python.framework/Versions/2.7/bin:${PATH}
# PATH=/usr/local/mysql/bin:${PATH}
# M2_HOME=/usr/local/maven
# PATH=${M2_HOME}/bin:${PATH}

include "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
[[ -s "$HOME/.rvm/scripts/rvm" ]] && rvm use 1.9.3@ror3.2 --default

include "$HOME/.nvm/nvm.sh"
