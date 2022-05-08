-- Autocommand that applies chezmoi config on save
local cz_dir = vim.env.HOME .. "/.config/local/share/chezmoi/*"
local cz_grp = vim.api.nvim_create_augroup("chezmoi_apply", { clear = true })
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = cz_dir,
  command = '! chezmoi apply --source-path "%"',
  group = cz_grp
})

vim.cmd('autocmd FileType go setlocal shiftwidth=3 tabstop=3')

vim.cmd('command -nargs=1 Browse silent exe "!xdg-open " . "<args>"')
