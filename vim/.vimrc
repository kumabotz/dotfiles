" change color scheme
syntax on
color blackboard

" shortcut to rapidly toggle `set list`
nmap <leader>l :set list!<CR>

" use the same symbols as TextMate for tabstops and EOLs
set list
set listchars=tab:▸\ ,eol:¬

" invisible character colors
hi NonText ctermfg=7 guifg=gray
hi SpecialKey ctermfg=7 guifg=gray
