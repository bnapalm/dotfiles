if vim.g.neovide then
  vim.g.neovide_scale_factor = 1.0
  local change_scale_factor = function(delta)
    vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * delta
  end
  vim.keymap.set({ 'n', 'i' }, "<C-+>", function()
    change_scale_factor(1.1)
  end)
  vim.keymap.set({ 'n', 'i' }, "<C-->", function()
    change_scale_factor(1 / 1.1)
  end)
  vim.keymap.set({ 'n', 'i' }, "<C-BS>", function()
    vim.g.neovide_scale_factor = 1.0
  end)

  vim.g.neovide_input_ime = true

  -- mac
  vim.g.neovide_input_use_logo = 1 -- enable use of the logo (cmd) key
  vim.g.neovide_input_macos_alt_is_meta = 1
  vim.keymap.set("n", "<M-m>", "<C-w>h")
  vim.keymap.set("n", "<M-w>", "<C-w>j")
  vim.keymap.set("n", "<M-v>", "<C-w>k")
  vim.keymap.set("n", "<M-z>", "<C-w>l")
  vim.keymap.set("n", "<M-l>", ":bnext<CR>")
  vim.keymap.set("n", "<M-h>", ":bprevious<CR>")
end
