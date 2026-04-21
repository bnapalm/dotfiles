local _unpack = table.unpack or unpack

local function pi(method, ...)
  local args = { ... }

  return function()
    require("pi")[method](_unpack(args))
  end
end

return {
  "alex35mil/pi.nvim",

  -- Optional: required only for `:PiPasteImage` (clipboard image paste).
  dependencies = { "HakonHarnes/img-clip.nvim" },

  -- if you're fine with defaults:
  -- config = true,

  keys = {
    { "<Leader>mp", pi("toggle"),                     mode = { "n", "v" },      desc = "Pi toggle" },
    { "<C-q>",      pi("toggle"),                     mode = { "n", "v", "i" }, desc = "Pi toggle" },
    { "<Leader>mf", pi("show", { layout = "float" }), mode = { "n", "v" },      desc = "Pi float" },
    { "<Leader>ml", pi("toggle_layout"),              mode = { "n", "v" },      desc = "Pi toggle layout" },
    { "<Leader>mc", pi("continue_session"),           mode = { "n", "v" },      desc = "Pi continue last session" },
    { "<Leader>mr", pi("resume_session"),             mode = { "n", "v" },      desc = "Pi resume past session" },
    { "<Leader>mm", pi("send_mention"),               mode = { "n", "v" },      desc = "Pi mention file/selection" },
    { "<Leader>ma", pi("attention"),                  mode = { "n", "v" },      desc = "Pi open next attention request" },
    { "<A-g>",      pi("focus_chat_prompt"),          mode = { "n", "v", "i" }, ft = "pi-chat-history",                 desc = "Pi focus chat prompt" },
    { "<A-g>",      pi("focus_chat_attachments"),     mode = { "n", "v", "i" }, ft = "pi-chat-prompt",                  desc = "Pi focus chat attachments" },
    { "<A-f>",      pi("focus_chat_history"),         mode = { "n", "v", "i" }, ft = "pi-chat-prompt",                  desc = "Pi focus chat history" },
    { "<A-f>",      pi("focus_chat_prompt"),          mode = { "n", "v", "i" }, ft = "pi-chat-attachments",             desc = "Pi focus chat prompt" },
  },

  -- or, if you want to customize:
  opts = {
    models = {
      { match = "gpt-5.4",      exact = true },
      { match = "gpt-5.4-mini", exact = true },
      { match = "kimi-k2.5",    exact = true },
    },
    -- layout = { ... },
  },
}
