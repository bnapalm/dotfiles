vim.g.gui_font_default_size = 12
vim.g.gui_font_size = vim.g.gui_font_default_size
vim.g.gui_font_face = "FiraCode Nerd Font Mono"

RefreshGuiFont = function()
  vim.opt.guifont = string.format("%s:h%s",vim.g.gui_font_face, vim.g.gui_font_size)
end

ResizeGuiFont = function(delta)
  vim.g.gui_font_size = vim.g.gui_font_size + delta
  RefreshGuiFont()
end

ResetGuiFont = function ()
  vim.g.gui_font_size = vim.g.gui_font_default_size
RefreshGuiFont()
end

ResetGuiFont()

local opts = { noremap = true, silent = true }

-- Shorten function name
local keymap = vim.keymap.set

-- neovide mac
if vim.g.neovide then
  vim.g.neovide_input_use_logo = 1 -- enable use of the logo (cmd) key
  vim.g.neovide_input_macos_alt_is_meta = 1
  keymap("n", "<M-m>", "<C-w>h", opts)
  keymap("n", "<M-w>", "<C-w>j", opts)
  keymap("n", "<M-v>", "<C-w>k", opts)
  keymap("n", "<M-z>", "<C-w>l", opts)
  keymap("n", "<M-l>", ":bnext<CR>", opts)
  keymap("n", "<M-h>", ":bprevious<CR>", opts)
end

