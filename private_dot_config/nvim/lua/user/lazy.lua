local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup("user.plugins", {
  concurrency = 8,
  checker = {
    concurrency = 8,
  },
})

local function ensure_ghgj_master()
  if vim.system({ "ssh", "-O", "check", "ghgj" }):wait().code ~= 0 then
    vim.system({ "ssh", "-MNf", "ghgj" }):wait()
  end
end

vim.api.nvim_create_autocmd("User", {
  pattern = {
    "LazyUpdatePre",
    "LazySyncPre",
    "LazyCheckPre",
    "LazyInstallPre",
    "LazyRestorePre",
  },
  callback = ensure_ghgj_master,
})
