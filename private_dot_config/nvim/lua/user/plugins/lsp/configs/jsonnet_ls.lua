-- local function getRoot()
--   local ret = vim.system({ 'git', 'rev-parse', '--show-toplevel' },
--     { cwd = vim.fs.dirname(vim.api.nvim_buf_get_name(0)), text = true }):wait()
--   if ret.code ~= 0 then
--     return ""
--   end
--   return string.gsub(ret.stdout, '\n', '')
-- end
--
-- local jpathVal = function()
--   local gitRoot = getRoot()
--   if gitRoot ~= "" then
--     return {
--       gitRoot .. "/utopia/lib",
--       gitRoot .. "/utopia/jvendor",
--     }
--   else
--     return {}
--   end
-- end

local util = require 'lspconfig.util'

-- Utopia jsonnet library paths
local function jsonnet_path(root_dir)
  local gitroot = util.find_git_ancestor(vim.api.nvim_buf_get_name(0))

  return {
    util.path.join(root_dir, 'lib'),
    util.path.join(root_dir, 'vendor'),
    util.path.join(gitroot, 'utopia', 'lib'),
    util.path.join(gitroot, 'utopia', 'jvendor'),
    -- util.path.join(root_dir, 'jvendor'),
    -- util.path.join(root_dir, '..', 'utopia', 'jvendor'),
    -- util.path.join(root_dir, '..', 'utopia', 'jvendor'),
  }
end

-- Derive the "topFile" external variable
local function topFileFunc()
  local bufname = vim.api.nvim_buf_get_name(0)
  if string.find(bufname, '.jsonnet') then
    return bufname
  else
    return nil
  end
end

return {
  cmd = {
    "jsonnet-language-server",
    "--lint"
  },

  before_init = function(_, config)
    config.settings = config.settings or {}
    config.settings.jpath = jsonnet_path(config.root_dir)

    local top_file = topFileFunc()

    -- We only want the LSP to evaluate the whole file when working on .jsonnet
    -- files, as opposed to .libsonnet files, which would most often present
    -- errors when evaluated on their own. topFileFunc() returning a value
    -- implies a .jsonnet file.
    if top_file then
      config.settings.ext_vars.topFile = top_file
      config.cmd = {
        "jsonnet-language-server",
        "--eval-diags",
        "--lint"
      }
    end
  end,

  -- This overrides the default nvim-lspconfig function. The function is called
  -- each time a new root_dir is found. This has the unfortunate side effect
  -- that when switching buffers from a .jsonnet to .libsonnet or vice versa
  -- in the same repo, the same LSP is reused and the new config will not be
  -- reevaluated. So if you need to refresh the topFile or enable/disable
  -- eval according to the current buffer, you need to either restart neovim
  -- or probably `:LspRestart` would also work.
  on_new_config = function(new_config, root_dir)
    -- This is removed from default function. It's meant to include standard
    -- jsonnet/tanka paths, but ours are different.
    --
    -- if not new_config.cmd_env then
    --   new_config.cmd_env = {}
    -- end
    -- if not new_config.cmd_env.JSONNET_PATH then
    --   new_config.cmd_env.JSONNET_PATH = table.concat(jsonnet_path(root_dir), ':')
    -- end

    -- This updates with the correct library paths, even if your anu location
    -- is not static. For example with git worktrees.
    new_config.settings.jpath = jsonnet_path(root_dir)

    local top_file = topFileFunc()

    -- We only want the LSP to evaluate the whole file when working on .jsonnet
    -- files, as opposed to .libsonnet files, which would most often present
    -- errors when evaluated on their own. topFileFunc() returning a value
    -- implies a .jsonnet file.
    if top_file then
      new_config.settings.ext_vars.topFile = top_file
      new_config.cmd = {
        "jsonnet-language-server",
        "--eval-diags",
        "--lint"
      }
      -- otherwise skip evaluation and just do plain LSP + linting
    else
      new_config.cmd = {
        "jsonnet-language-server",
        "--lint"
      }
    end
  end,
  settings = {
    -- adding some ext_vars used in some files does no harm
    ext_vars = {
      revision = "no-revision",
      service = "payments-service",
      environment = "sandbox-staging",
      project_id = "gc-prd-paysvc-sbx-stag-d54a",
    },
  },
}
