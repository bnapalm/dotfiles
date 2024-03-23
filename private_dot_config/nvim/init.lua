require "user.options"
require "user.keymaps"
require "user.commands"
require "user.lazy"
require "user.diagnostics"
require "user.neovide"
--[[ require "user.cmp" ]]
--[[ require "user.lsp" ]]
--[[ require "user.telescope" ]]
--[[ require "user.treesitter" ]]
--[[ require "user.autopairs" ]]
--[[ require "user.comment" ]]
--[[ require "user.lualine" ]]
--[[ require "user.bufferline" ]]
--[[ require "user.gitsigns" ]]
--[[ require "user.project" ]]
--[[ require "user.indent" ]]
--[[ require "user.neo-tree" ]]
--[[ require "user.neorg" ]]
--[[ require "user.harpoon" ]]
--[[ require "user.undotree" ]]
--[[ require "user.treesj" ]]
--
-- remove this later
local function getRoot()
  local ret = vim.system({ 'git', 'rev-parse', '--show-toplevel' },
    { cwd = vim.fs.dirname(vim.api.nvim_buf_get_name(0)), text = true }):wait()
  if ret.code ~= 0 then
    return ""
  end
  return string.gsub(ret.stdout, '\n', '')
end

local function jsnet_root()
  return vim.fs.dirname(vim.fs.find(
    { 'jsonnetfile.json' },
    { upward = true }
  )[1]) or getRoot() or vim.fn.getcwd()
end

-- Utopia jsonnet library paths
local function jsonnet_path(root_dir)
  return {
    root_dir .. 'lib',
    root_dir .. 'jvendor',
    root_dir .. 'vendor',
  }
end

vim.api.nvim_create_autocmd("BufEnter", {
  pattern = { "*.jsonnet", "*.libsonnet" },
  callback = function()
    local jsr = jsnet_root()
    vim.lsp.start({
      name = 'custom-jsonnet-lsp',
      cmd = { 'jsonnet-lsp', 'lsp' },
      root_dir = jsr,
      settings = {
        jpaths = jsonnet_path(jsr),
      },
    })
  end
})
