-- Autocommand that applies chezmoi config on save
vim.cmd [[
  augroup chezmoi_apply
    autocmd!
    autocmd BufWritePost ~/.config/local/share/chezmoi/* ! chezmoi apply --source-path "%"
  augroup end
]]
