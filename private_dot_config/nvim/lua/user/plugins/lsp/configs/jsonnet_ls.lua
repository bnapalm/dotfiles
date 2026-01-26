-- Determine jpath based on file path and git root
local function determine_jpath(file_path, git_root)
  -- Normalize paths - get relative path from git root
  local rel_path = file_path:sub(#git_root + 2)

  if rel_path:match("^kubernetes/") then
    return {
      vim.fs.joinpath(git_root, "kubernetes", "lib"),
      vim.fs.joinpath(git_root, "kubernetes", "vendor"),
    }
  else
    -- Default: utopia paths (for utopia/, root files, or any other location)
    return {
      vim.fs.joinpath(git_root, "utopia", "lib"),
      vim.fs.joinpath(git_root, "utopia", "jvendor"),
    }
  end
end

-- Check if file needs eval-diags (is .jsonnet, not .libsonnet)
local function needs_eval_diags(file_path)
  return file_path:match("%.jsonnet$") ~= nil
end

-- Compare two jpath arrays for equality
local function jpath_equal(a, b)
  if #a ~= #b then return false end
  for i, v in ipairs(a) do
    if v ~= b[i] then return false end
  end
  return true
end

return {
  filetypes = { "jsonnet", "libsonnet" },

  cmd = function(dispatchers, config)
    local bufname = vim.api.nvim_buf_get_name(0)
    local cmd_args = { "jsonnet-language-server", "--lint", "--show-docstrings" }

    if needs_eval_diags(bufname) then
      table.insert(cmd_args, 2, "--eval-diags")  -- Insert after server name
    end

    return vim.lsp.rpc.start(cmd_args, dispatchers, {
      cwd = config.cmd_cwd,
      env = config.cmd_env,
    })
  end,

  root_dir = function(bufnr, on_dir)
    -- Find root by jsonnetfile.json or .git
    local jsonnetfile_root = vim.fs.root(bufnr, "jsonnetfile.json")
    local git_root = vim.fs.root(bufnr, ".git")

    -- Prefer jsonnetfile.json location, fall back to git root
    local root = jsonnetfile_root or git_root

    if root then
      on_dir(root)
    end
  end,

  reuse_client = function(client, config)
    -- Different LSP or stopped? Never reuse
    if client.name ~= config.name or client:is_stopped() then
      return false
    end

    local bufname = vim.api.nvim_buf_get_name(0)

    -- Eval-diags mode must match
    if client.config._has_eval_diags ~= needs_eval_diags(bufname) then
      return false
    end

    -- jpath must match
    local git_root = vim.fs.root(0, ".git")
    if not git_root then
      return false
    end

    local new_jpath = determine_jpath(bufname, git_root)
    local existing_jpath = client.config.settings and client.config.settings.jpath or {}

    return jpath_equal(new_jpath, existing_jpath)
  end,

  before_init = function(params, config)
    local bufname = vim.api.nvim_buf_get_name(0)
    local git_root = vim.fs.root(0, ".git")

    config.settings = config.settings or {}
    config.settings.ext_vars = config.settings.ext_vars or {}

    -- Set jpath based on file location
    if git_root then
      config.settings.jpath = determine_jpath(bufname, git_root)
    end

    -- Track whether this client has eval-diags (for reuse_client check)
    config._has_eval_diags = needs_eval_diags(bufname)
  end,

  settings = {
    -- Some files still use ext_vars, define dummy values here, that should
    -- still evaluate correctly.
    -- We would want to inject TLA vars when needed, but current
    -- jsonnet-language-server doesn't support that. We could fork it or look
    -- for different LSP.
    ext_vars = {
      revision = "no-revision",
      context = "compute-lab",
    },
  },
}
