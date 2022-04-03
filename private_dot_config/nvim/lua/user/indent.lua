local status_ok, indent = pcall(require, "indent_blankline")
if not status_ok then
  return
end

vim.cmd [[highlight IndentBlanklineContextChar  guifg=green gui=nocombine]]
vim.cmd [[highlight IndentBlanklineContextStart guisp=green gui=underline]]

indent.setup({
  space_char_blankline = " ",
  show_current_context = true,
  show_current_context_start = true,
})
