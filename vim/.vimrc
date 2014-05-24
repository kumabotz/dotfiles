set nocompatible

call pathogen#infect()

" --------
" 0. general
" --------
let mapleader="\<Space>"

" hide the insert status in vim
set noshowmode

" display the status line always to see current mode, file name, file status, ruler
set laststatus=2

set encoding=utf-8
set fileencodings=utf-8

" set how many lines of history vim has to remember
set history=300

" enable filetype plugins
filetype plugin indent on

" set to auto read when a file is changed from the outside
set autoread

" set 7 lines scroll offset to the cursor - when moving vertically using j/k
set so=7

" turn on the wild menu
set wildmode=list:longest,full
set wildignore+=*/tmp/*

" always show current position
"set ruler " ruler is already enabled by powerline

" height of the command bar
set cmdheight=1 " default is 1

" a buffer becomes hidden when it is abandoned
set hid

" make backspace work like most other apps
set backspace=eol,start,indent

" automatically wrap left and right
set whichwrap+=<,>,h,l

" ignore case when searching
set ignorecase

" when searching try to be smart about cases
set smartcase

" highlight search results
set hlsearch

" make search act like search in modern browsers
set incsearch

" don't redraw while executing macros (good for performance config)
set lazyredraw

" for regular expressions turn magic on
set magic

" show matching brackets when text indicator is over them
set showmatch

" how many tenths of a second to blink when matching brackets
set mat=5

" add a bit extra margin to the left
"set foldcolumn=1

" enable syntax highlighting
syntax enable
set bg=dark
set t_Co=256 "enable 256 colors
colorscheme "wombat"

set pastetoggle=<F2>

set cursorline
"set cursorcolumn

" turn backup off, since most stuff is in vcs anyway
set nobackup
set nowb
set noswapfile

" line number
set nu

" use spaces instead of tabs (expandtab)
set et

" be smart when using tabs
set smarttab

" use system clipboard
if $TMUX == ''
  set clipboard+=unnamed
endif

" 1 tab is 2 spaces (tabstop, softtabstop, shiftwidth, expandtab)
set ts=2 sts=2 sw=2

set ai " autoindent
set si " smart indent
set wrap linebreak textwidth=0 " wrap lines

" show invisible characters
set list
set listchars=tab:▸\ ,trail:❤,eol:¬

" visual mode pressing * or # searches for the current selection
" super useful idea by Michael Naumann
vnoremap <silent> * :call VisualSelection('f', '')<CR>
vnoremap <silent> # :call VisualSelection('b', '')<CR>

" persistent undo
set undodir=~/.vim/undodir
set undofile
set undolevels=1000 " maximum number of changes that can be undone
set undoreload=10000 " maximum number lines to save for undo on a buffer reload

" only do this part when support autocommands
if has("autocmd")
  " enable file type detection
  filetype on

  " syntax of these languages is fussy over tabs vs spaces
  autocmd FileType make setlocal ts=2 sts=2 sw=2 noet

  " remove trailing spaces when saved
  autocmd BufWritePre * :call <SID>StripTrailingWhitespaces()

  " return to last edit position when opening files
  autocmd BufReadPost *
      \ if line("'\"") > 0 && line("'\"") <= line("$") |
      \   exe "normal! g`\"" |
      \ endif
endif"

" remember info about open buffers on close
set viminfo^=%

" treat long lines as break lines (usefull when moving around in them)
noremap j gj
noremap k gk

" specify the behavior when switching between buffers
try
  set switchbuf=useopen,usetab,newtab
catch
endtry

" map auto complete of (, ", ', [
inoremap ( ()<esc>i
inoremap $2 []<esc>i
inoremap $3 {}<esc>i
inoremap $4 {<esc>o}<esc>O
inoremap $q ''<esc>i
inoremap $e ""<esc>i
inoremap $t <><esc>i)

" map jk to esc
imap jk <esc>
imap Jk <esc>

" shortcut
map <C-f> :Ag
map <Leader>t :tabnew<CR>
nnoremap <Leader>w :w<CR>  " save
nnoremap <Leader>q :q<CR>  " quit
nnoremap <Leader>e :wq<CR> " save and quit
nnoremap <CR> G  " end of file
nnoremap <BS> gg " begin of file

" vp doesn't replace paste buffer
vmap <silent> <expr> p <sid>Repl()

" copy paste with space y/p
vmap <Leader>y "+y
vmap <Leader>d "+d
nmap <Leader>p "+p
nmap <Leader>P "+P
vmap <Leader>p "+p
vmap <Leader>P "+P

" --------
" 1. nerdtree.vim
" --------
map <Leader>n :NERDTreeToggle<CR>
map <Leader>r :NERDTreeFind<CR>

au VimEnter * NERDTree
let g:nerdtree_tabs_open_on_console_startup=1
let g:nerdtree_tabs_smart_startup_focus=2

" lightline config
let g:powerline_symbols = 'fancy'
let g:lightline = {
      \ 'mode_map': { 'c': 'NORMAL' },
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ], [ 'fugitive', 'filename' ] ]
      \ },
      \ 'component_function': {
      \   'modified': 'MyModified',
      \   'readonly': 'MyReadonly',
      \   'fugitive': 'MyFugitive',
      \   'filename': 'MyFilename',
      \   'fileformat': 'MyFileformat',
      \   'filetype': 'MyFiletype',
      \   'fileencoding': 'MyFileencoding',
      \   'mode': 'MyMode',
      \ },
      \ 'separator': { 'left': '➜', 'right': '⬅' },
      \ 'subseparator': { 'left': '❯', 'right': '❮' }
      \ }

" --------
" *. helper functions
" --------
function! MyModified()
  return &ft =~ 'help\|vimfiler\|gundo' ? '' : &modified ? '+' : &modifiable ? '' : '-'
endfunction

function! MyReadonly()
  return &ft !~? 'help\|vimfiler\|gundo' && &readonly ? '(╯°□°）╯︵ ┻━┻' : ''
endfunction

function! MyFugitive()
  if &ft !~? 'vimfiler\|gundo' && exists("*fugitive#head")
    let _ = fugitive#head()
    return strlen(_) ? 'ಠ_ಠ '._ : ''
  endif
  return ''
endfunction

function! MyFilename()
  return ('' != MyReadonly() ? MyReadonly() . ' ' : '') .
        \ (&ft == 'vimfiler' ? vimfiler#get_status_string() :
        \  &ft == 'unite' ? unite#get_status_string() :
        \  &ft == 'vimshell' ? vimshell#get_status_string() :
        \ '' != expand('%:t') ? expand('%:t') : '[No Name]') .
        \ ('' != MyModified() ? ' ' . MyModified() : '')
endfunction

function! MyFileformat()
  return winwidth(0) > 70 ? &fileformat : ''
endfunction

function! MyFiletype()
  return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype : 'no ft') : ''
endfunction

function! MyFileencoding()
  return winwidth(0) > 70 ? (strlen(&fenc) ? &fenc : &enc) : ''
endfunction

function! MyMode()
  return winwidth(0) > 60 ? lightline#mode() : ''
endfunction

function! <SID>StripTrailingWhitespaces()
  " preparation: save last search, and cursor position
  let _s=@/
  let l = line(".")
  let c = col(".")

  " do the business
  %s/\s\+$//e

  " clean up: restore previous search history, and cursor position
  let @/=_s
  call cursor(l, c)
endfunction"

function! VisualSelection(direction, extra_filter) range
  let l:saved_reg = @"
  execute "normal! vgvy"

  let l:pattern = escape(@", '\\/.*$^~[]')
  let l:pattern = substitute(l:pattern, "\n$", "", "")

  if a:direction == 'b'
    execute "normal ?" . l:pattern . "^M"
  elseif a:direction == 'gv'
    call CmdLine("vimgrep " . '/' . l:pattern . '/' . ' **/*.' . a:extra_filter)
  elseif a:direction == 'replace'
    call CmdLine("%s" . '/' . l:pattern . '/')
  elseif a:direction == 'f'
    execute "normal /" . l:pattern . "^M"
  endif

  let @/ = l:pattern
  let @" = l:saved_reg
endfunction

function! RestoreRegister()
  let @" = s:restore_reg
  return ''
endfunction

function! s:Repl()
  let s:restore_reg = @"
  return "p@=RestoreRegister()\<CR>"
endfunction
