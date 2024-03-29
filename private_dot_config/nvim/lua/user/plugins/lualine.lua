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

local noice_macro_str = function()
  local ok, noice = pcall(require, "noice")
  local nmode
  if ok then
    nmode = noice.api.statusline.mode.get()
  end

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
          noice_macro_str,
          cond = require("noice").api.statusline.mode.has,
          color = { fg = "orange" },
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
