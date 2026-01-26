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
    local cmd_args = { "jsonnet-language-server", "--lint" }

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
    -- Different LSP? Never reuse
    if client.name ~= config.name then
      return false
    end

    -- Client stopped? Can't reuse
    if client:is_stopped() then
      return false
    end

    local bufname = vim.api.nvim_buf_get_name(0)

    -- If new file needs eval → always create new server (file-specific topFile)
    -- Early exit - no need to check existing client
    if needs_eval_diags(bufname) then
      return false
    end

    -- Check if existing client has eval-diags (can't reuse eval server for non-eval file)
    if client.config._has_eval_diags then
      return false
    end

    -- Check jpath matches
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
    local has_eval = needs_eval_diags(bufname)
    config._has_eval_diags = has_eval

    -- Set topFile only for .jsonnet files (when eval-diags is enabled)
    if has_eval then
      config.settings.ext_vars.topFile = bufname
    end
  end,

  settings = {
    ext_vars = {
      revision = "no-revision",
      service = "payments-service",
      environment = "sandbox-staging",
      project_id = "gc-prd-paysvc-sbx-stag-d54a",
    },
  },
}
