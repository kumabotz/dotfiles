" color scheme
syntax on
color blackboard

" invisible charater colors
hi NonText ctermfg=DarkGray
hi SpecialKey ctermfg=DarkGray

" basic
set number
set hlsearch
set list
set listchars=tab:▸\ ,trail:❤,eol:¬

" default indentation: 2 spaces
set ts=2 sts=2 sw=2 et

" only do this part when compiled with support for autocommands
if has("autocmd")
  " enable file type detection
  filetype on

  " syntax of these languages is fussy over tabs vs spaces
  autocmd FileType make setlocal ts=2 sts=2 sw=2 noet

  " remove trailing spaces when saved
  autocmd BufWritePre * :call <SID>StripTrailingWhitespaces()
endif

" shortcut to rapidly toggle `set list`
nmap <leader>l :set list!<CR>

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
endfunction

