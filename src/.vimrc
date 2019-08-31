set number
set numberwidth=3

set autoindent
set tabstop=4
set shiftwidth=4
set expandtab

set clipboard=unnamed

set nowrap
syntax on

set cursorline
highlight CursorLine cterm=None ctermbg=22
highlight CursorLineNr ctermfg=247 ctermbg=22
highlight LineNr ctermfg=247

inoremap jj <ESC>
nnoremap <Enter> o<Esc>

set showtabline=2
nnoremap tn :tabnew<CR>

set list
set listchars=tab:>>,trail:-,extends:»,precedes:«,nbsp:%

command Delwhspace %s/\s\+$//ge <bar> normal <C-o>
command Tab2space retab! 4

