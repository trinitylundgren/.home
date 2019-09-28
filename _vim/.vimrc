" Make sure we're not trying to be Vi-compatible. This must be first.
set nocompatible

" Overriden by ftplugin and rules in .vim/after/ftplugin/<filetype>.vim
set expandtab
set shiftwidth=4
set softtabstop=4
set tabstop=4

" Enable file-type detection, plugins, and auto indentation
filetype plugin indent on

" File-type associations
au BufRead,BufNewFile *.md set filetype=markdown

" Miscellaneous
set number
set hlsearch

" Enable syntax highlighting
syntax enable

" Change background color after 80 columns
if exists('+colorcolumn')
    let &colorcolumn=join(range(81,999),",")
    highlight ColorColumn ctermbg=7
endif

" Call matchadd for all new windows
"
" :match only defines a match in the current window. In order to match across
" all windows, matchadd() needs to be called once in each new window. However,
" none of the autocmd events do exactly that [1]. The combination of VimEnter
" and WinEnter will work, but will also be triggered switching between open
" windows. The window local variable w:created guards against this.
"
"   [1]: http://vim.wikia.com/wiki/Detect_window_creation_with_WinEnter
autocmd VimEnter,WinEnter * if !exists('w:created') | call NewWindow() | endif
function NewWindow()
    let w:created=1
    " -1 priority so hlsearch (priority 0) will override the match
    " Alternate implementation of colorcolumn for older versions
    if !exists('+colorcolumn')
        call matchadd('CursorColumn', '\%>80v.\+', -1)
    endif
    " Highlight trailing whitespace and space before tab
    call matchadd('ErrorMsg', '\s\+$\| \+\ze\t', -1)
endfunction
