-- Check if in gocardless/anu repo
local function is_anu_repo(git_root)
  if not git_root then return false end
  local result = vim.system(
    { "git", "-C", git_root, "remote", "get-url", "origin" },
    { text = true }
  ):wait()
  if result.code ~= 0 or not result.stdout then return false end
  return result.stdout:match("gocardless/anu") ~= nil
end

-- Determine jpath based on repo, file path, and roots
local function determine_jpath(file_path, root_dir, git_root)
  -- Standard pattern: base/lib, base/vendor
  local function standard_jpath(base)
    return {
      vim.fs.joinpath(base, "lib"),
      vim.fs.joinpath(base, "vendor"),
    }
  end

  -- Non-Anu repos: use standard pattern from root_dir
  if not is_anu_repo(git_root) then
    return standard_jpath(root_dir)
  end

  -- In Anu: check if in kubernetes/ (relative to git root)
  local rel_path = file_path:sub(#git_root + 2)
  if rel_path:match("^kubernetes/") then
    return standard_jpath(vim.fs.joinpath(git_root, "kubernetes"))
  end

  -- In Anu, not kubernetes: use utopia paths (with jvendor instead of vendor)
  return {
    vim.fs.joinpath(git_root, "utopia", "lib"),
    vim.fs.joinpath(git_root, "utopia", "jvendor"),
  }
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
      table.insert(cmd_args, 2, "--eval-diags")
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
    local new_jpath = determine_jpath(bufname, config.root_dir, git_root)
    local existing_jpath = client.config.settings and client.config.settings.jpath or {}

    return jpath_equal(new_jpath, existing_jpath)
  end,

  before_init = function(params, config)
    local bufname = vim.api.nvim_buf_get_name(0)
    local git_root = vim.fs.root(0, ".git")

    config.settings = config.settings or {}

    -- Set jpath based on repo and file location
    config.settings.jpath = determine_jpath(bufname, config.root_dir, git_root)

    -- Only set ext_vars in Anu repo
    if is_anu_repo(git_root) then
      config.settings.ext_vars = {
        revision = "no-revision",
        context = "compute-lab",
      }
    end

    -- Track eval-diags mode for reuse_client
    config._has_eval_diags = needs_eval_diags(bufname)
  end,

  -- without this, the modifications in before_init are not applied
  settings = {},
}
