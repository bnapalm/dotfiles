-- Autocommand that applies chezmoi config on save
local cz_dir = vim.env.HOME .. "/.config/local/share/chezmoi/*"
local cz_grp = vim.api.nvim_create_augroup("chezmoi_apply", { clear = true })
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = cz_dir,
  command = '! chezmoi apply --source-path "%"',
  group = cz_grp
})

-- set go indentation to 3 chars
local go_grp = vim.api.nvim_create_augroup("go_group", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  pattern = "go",
  command = "setlocal shiftwidth=3 tabstop=3",
  group = go_grp
})

vim.cmd('command -nargs=1 Browse silent exe "!xdg-open " . "<args>"')
