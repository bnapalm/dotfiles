local active_ws = function()
  local ok, ws = pcall(require, "workspaces")
  local ws_name
  if ok then
    ws_name = ws.name()
  end

  if ws_name then
    return ws_name
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
        require("noice").api.status.command.get,
        cond = require("noice").api.status.command.has,
        color = { fg = "#ff9e64" },
      },
      {
        require("noice").api.status.mode.get,
        cond = require("noice").api.status.mode.has,
        color = { fg = "#ff9e64" },
      },
      {
        require("noice").api.status.search.get,
        cond = require("noice").api.status.search.has,
        color = { fg = "#ff9e64" },
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
