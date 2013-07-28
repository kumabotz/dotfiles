SSH_ENV="$HOME/.ssh/environment"

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

# PS1='\u@\h:\w\$ '
PS1='\[\e[1;33m\]\w\[\e[0m\] '
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
export LSCOLORS=dxgxhxdxbxegedabagacad

# aliases
if [ -f ~/.bash_aliases ]; then
  . ~/.bash_aliases
fi

export ANDROID='/Applications/android-sdk-macosx'
export ANDROID_HOME='/Applications/android-sdk-macosx'
export ANDROID_VIEW_CLIENT_HOME='/usr/local/bin/AndroidViewClient'
export MAGICK_HOME='/usr/local/Cellar/imagemagick/6.7.7-6'
export DYLD_LIBRARY_PATH="$MAGICK_HOME/lib/"

# export PATH=/usr/local/Cellar/ruby/1.9.3-p194/bin/:/opt/local/bin:/opt/local/sbin:/usr/local/bin:$PATH
export PATH=$ANDROID_HOME/platform-tools:$ANDROID_HOME/tools:/usr/local/maven/bin:/usr/local/mysql/bin:$HOME/.rvm/gems/ruby-1.9.3-p194/bin:$HOME/.rvm/gems/ruby-1.9.3-p194@global/bin:$HOME/.rvm/rubies/ruby-1.9.3-p194/bin:$HOME/.rvm/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/X11/bin:/usr/local/git/bin:/usr/X11/bin:${PATH}

# PATH=/Library/Frameworks/Python.framework/Versions/2.7/bin:${PATH}
# PATH=/usr/local/mysql/bin:${PATH}
# M2_HOME=/usr/local/maven
# PATH=${M2_HOME}/bin:${PATH}

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
