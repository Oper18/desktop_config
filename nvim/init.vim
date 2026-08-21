" init.vim — entrypoint
" This config is Lua-first; Vimscript is only used as the entrypoint.
set nocompatible
filetype plugin indent on
syntax on

" If you keep Lua config under ~/.config/nvim/lua/, this will work out of the box.
lua require("init")
