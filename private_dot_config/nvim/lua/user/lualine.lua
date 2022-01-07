local status_ok, lualine = pcall(require, "lualine")
if not status_ok then
  return
end

lualine.setup({
  options = {
    icons_enabled = true,
    theme = "gruvbox",
  },
  tabline = {
    lualine_a = {},
    lualine_b = {
      {
        'buffers',
        show_filename_only = false,
        max_length = vim.o.columns * 5 / 4
      }
    }
  }
})
