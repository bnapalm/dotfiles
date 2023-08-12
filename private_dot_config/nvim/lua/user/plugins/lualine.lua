return {
  "nvim-lualine/lualine.nvim",
  lazy = false,
  opts = {
    options = {
      icons_enabled = true,
      theme = "gruvbox",
      globalstatus = true,
    },

    sections = {
      lualine_c = {
        {
          'filename',
          file_status = true, -- Displays file status (readonly status, modified status)
          path = 3,           -- 0: Just the filename
                              -- 1: Relative path
                              -- 2: Absolute path
                              -- 3: Absolute path, with tilde as the home directory

          shorting_target = 40, -- Shortens path to leave 40 spaces in the window
          symbols = {
            modified = '[+]',      -- Text to show when the file is modified.
            readonly = '[-]',      -- Text to show when the file is non-modifiable or readonly.
            unnamed = '[No Name]', -- Text to show for unnamed buffers.
          }
        }
      },
      lualine_x = {
        {
          require("noice").api.statusline.mode.get,
          cond = require("noice").api.statusline.mode.has,
          color = { fg = "#ff9e64" },
        }
      },
    },
    extensions = {
      "neo-tree",
      "fugitive"
    }
  }
}
