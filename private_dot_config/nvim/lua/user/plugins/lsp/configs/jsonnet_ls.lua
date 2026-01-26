-- Utopia jsonnet library paths
local function jsonnet_path(root_dir)
  -- local gitroot = util.find_git_ancestor(vim.api.nvim_buf_get_name(0))

  local libParent = root_dir

  if vim.uv.fs_statfs(vim.fs.joinpath(root_dir, 'jsonnetfile.json')) then
    libParent = root_dir
  elseif vim.uv.fs_statfs(vim.fs.joinpath(root_dir, 'utopia')) then
    libParent = vim.fs.joinpath(root_dir, 'utopia')
  end

  return {
    vim.fs.joinpath(libParent, 'vendor'),
    vim.fs.joinpath(libParent, 'jvendor'),
    vim.fs.joinpath(libParent, 'lib'),
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

  -- reuse_client = function(client, config)
  --   -- skip if not in the same root dir or different lsp
  --   if client.root_dir ~= config.root_dir or client.name ~= config.name then
  --     return false
  --   end
  --
  --   local new_needs_eval = false
  --   local existing_has_eval = false
  --
  --   -- does existing client have eval
  --   for _, v in ipairs(client.config.cmd) do
  --     if v == "--eval-diags" then
  --       vim.notify("existing client has eval")
  --       existing_has_eval = true
  --     end
  --   end
  --
  --   -- do we need eval
  --   for _, v in ipairs(config.cmd) do
  --     if v == "--eval-diags" then
  --       vim.notify("new client needs eval")
  --       new_needs_eval = true
  --     end
  --   end
  --
  --   if existing_has_eval ~= new_needs_eval then
  --     return false
  --   end
  --
  --   return true
  -- end,

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
