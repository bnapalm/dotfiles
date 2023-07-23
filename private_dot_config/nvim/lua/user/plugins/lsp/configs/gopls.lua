return {
  cmd = { "gopls", "-remote=auto" },
  settings = {
    gopls = {
      usePlaceholders = true,
      analyses = {
        unusedparams = true,
      },
    }
  }
}
