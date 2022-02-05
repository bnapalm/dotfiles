-- Autocommand that applies chezmoi config on save
vim.cmd [[
  augroup chezmoi_apply
    autocmd!
    autocmd BufWritePost ~/.config/local/share/chezmoi/* ! chezmoi apply --source-path "%"
  augroup end
]]

vim.cmd('command -nargs=1 Browse silent exe "!xdg-open " . "<args>"')
