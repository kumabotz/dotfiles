## Steps

1. Set up [Vundle]:

   `$ git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim`

1. Symlink vimrc file
    -  `git clone git@github.com:kumabotz/dotfiles.git ~/dotfiles`
    - `ln -s ~/dotfiles/vimrc ~/.vimrc` 
    - alternatively, just update your ~/.vimrc file
1. Install Plugins:

   Launch `vim` and run `:PluginInstall`

   To install from command line: `vim +PluginInstall +qall`
   
1. Install [the_silver_searcher](https://github.com/ggreer/the_silver_searcher) (for Ag)

   `brew install the_silver_searcher`

1. Add the following to your .bash_profile or .zshrc 
   ```
   export LANG=en_US.UTF-8
   export LC_ALL=en_US.UTF-8
   ```

1. Put solarized colors into ~/.vim/colors
 
   `cp ~/.vim/bundle/vim-colors-solarized/colors/solarized.vim ~/.vim/colors/`

1. Profit!!!

## Sample Commands

1. `<Space>w` writes to file (save)
1. `<Space>q` quit
1. `<Space>e` write + quit
1. `<Space>t` new tab
1. `<Space>y` copy to clipboard
1. `<Space>p` paste from clipboard
1. `<Ctrl-n>` Open Nerdtree File Browsing (https://github.com/scrooloose/nerdtree)
1. `<Ctrl-f>` Search text using Ag (https://github.com/rking/ag.vim)
1. `<Ctrl-p>` Fuzzy file finder (https://github.com/kien/ctrlp.vim)

