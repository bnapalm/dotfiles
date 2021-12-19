Plug 'morhetz/gruvbox', {'as': 'gruvbox'}
augroup GruvboxConf
  au!
  autocmd ColorScheme gruvbox let g:gruvbox_italic=1
  autocmd User PlugLoaded ++nested colorscheme gruvbox
augroup end
