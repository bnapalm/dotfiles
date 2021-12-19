Plug 'lambdalisue/fern.vim'
Plug 'antoinemadec/FixCursorHold.nvim'
Plug 'lambdalisue/nerdfont.vim'
Plug 'lambdalisue/fern-renderer-nerdfont.vim'

let g:fern#renderer = "nerdfont"
function! s:fern_init() abort
  nmap <buffer> ā <Plug>(fern-action-open:select)
  nmap <buffer> s j
endfunction

augroup my-fern
  autocmd! *
  autocmd FileType fern call s:fern_init()
augroup END

" You need this otherwise you cannot switch modified buffer
" set hidden
