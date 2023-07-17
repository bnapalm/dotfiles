local status_ok, indent = pcall(require, "indent_blankline")
if not status_ok then
  return
end

local CustomHl = vim.api.nvim_get_hl_by_name('TabLineSel', true)
vim.api.nvim_set_hl(0, 'IndentBlanklineContextChar',  { fg = CustomHl.foreground })
vim.api.nvim_set_hl(0, 'IndentBlanklineContextStart', { sp = CustomHl.foreground, underline = true })

indent.setup({
  space_char_blankline = " ",
  show_current_context = true,
  show_current_context_start = true,
})
