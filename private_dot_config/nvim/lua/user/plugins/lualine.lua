local active_ws = function()
  local ws_name = require("workspaces").name()
  if ws_name then
    return ws_name
  end
  return ""
end

local noice = function()
  local nmode = require("noice").api.statusline.mode.get()
  local s, _ = string.find(nmode, "recording", 1, true)
  if s then
    return nmode
  else
    return ""
  end
end

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
        active_ws,
        {
          'filename',
          file_status = true, -- Displays file status (readonly status, modified status)
          path = 1,           -- 0: Just the filename
          -- 1: Relative path
          -- 2: Absolute path
          -- 3: Absolute path, with tilde as the home directory

          shorting_target = 40,    -- Shortens path to leave 40 spaces in the window
          symbols = {
            modified = '[+]',      -- Text to show when the file is modified.
            readonly = '[-]',      -- Text to show when the file is non-modifiable or readonly.
            unnamed = '[No Name]', -- Text to show for unnamed buffers.
          }
        }
      },
      lualine_x = {
        {
          noice,
          cond = require("noice").api.statusline.mode.has,
          color = { fg = require("gruvbox.palette").colors.bright_yellow },
        },
        'encoding',
        'fileformat',
        'filetype'
      },
    },
    extensions = {
      "neo-tree",
      "fugitive"
    }
  }
}
