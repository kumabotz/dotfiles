if [ -f ~/.bashrc ]; then
  source ~/.bashrc
fi

if [ -f ~/.bash_aliases ]; then
  source ~/.bash_aliases
fi

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

export PATH="/usr/local/sbin:/usr/local/bin:$PATH"
