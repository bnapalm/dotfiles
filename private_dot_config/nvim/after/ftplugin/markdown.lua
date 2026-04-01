vim.opt_local.formatoptions:append("ro")

-- TODO: replace local with one of the plugins:
-- - markdown-plus.nvim
-- - mdnotes.nvim
-- - mkdnflow.nvim

local function bullet_prefix()
  return vim.api.nvim_get_current_line():match("^(%s*[-*+]%s+)")
end

vim.keymap.set("i", "<CR>", function()
  local prefix = bullet_prefix()
  if prefix then
    return "<CR><C-u>" .. prefix
  end
  return "<CR>"
end, { expr = true, buffer = true, desc = "Continue markdown bullet" })

vim.keymap.set("n", "o", function()
  local prefix = bullet_prefix()
  if prefix then
    return "o<C-u>" .. prefix
  end
  return "o"
end, { expr = true, buffer = true, desc = "Open markdown bullet below" })

vim.keymap.set("n", "O", function()
  local prefix = bullet_prefix()
  if prefix then
    return "O<C-u>" .. prefix
  end
  return "O"
end, { expr = true, buffer = true, desc = "Open markdown bullet above" })
