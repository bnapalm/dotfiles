local my_default_lsp = {
  "lua_ls",
  "gopls"
}

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
    opts = {
      ensure_installed = my_default_lsp
    },
    config = function(_, opts)
      require("mason-lspconfig").setup(opts)

      require("mason-lspconfig").setup_handlers {
        function(server_name) -- default handler
          require("lspconfig")[server_name].setup {}
        end,
        ["lua_ls"] = function()
          require("lspconfig")["lua_ls"].setup(require("user.plugins.lsp.configs.lua_ls"))
        end,
      }
    end,
    dependencies = {
      "williamboman/mason.nvim"
    }
  }
}
