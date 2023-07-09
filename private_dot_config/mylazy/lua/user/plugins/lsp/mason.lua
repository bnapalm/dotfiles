return {
  {
    "williamboman/mason.nvim",
    lazy = true,
    build = ":MasonUpdate" -- :MasonUpdate updates registry contents
  },
  {
    "williamboman/mason-lspconfig.nvim",
    lazy = true,
    dependencies = {
      "williamboman/mason.nvim"
    }
  }
}
