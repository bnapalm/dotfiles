return {
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    keys = { { "<leader>cm", vim.cmd.Mason, desc = "Mason" } },
    opts = {
      ui = {
        icons = {
          package_installed = "󰝥",
          package_pending = "󱎖",
          package_uninstalled = "󰝦"
        }
      }
    },
    build = ":MasonUpdate", -- :MasonUpdate updates registry contents
  },
  {
    "williamboman/mason-lspconfig.nvim",
    lazy = true,
    config = true,
    dependencies = {
      "williamboman/mason.nvim"
    }
  }
}
