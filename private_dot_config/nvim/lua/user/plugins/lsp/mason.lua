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

      local lspconfig = require("lspconfig")
      local lsp_defaults = lspconfig.util.default_config

      lsp_defaults.capabilities = vim.tbl_deep_extend(
        "force",
        lsp_defaults.capabilities,
        require("cmp_nvim_lsp").default_capabilities()
      )

      require("mason-lspconfig").setup_handlers {

        function(server_name) -- default handler
          lspconfig[server_name].setup({})
        end,
        ["lua_ls"] = function()
          lspconfig["lua_ls"].setup(require("user.plugins.lsp.configs.lua_ls"))
        end,
        ["beancount"] = function()
          lspconfig["beancount"].setup(require("user.plugins.lsp.configs.beancount"))
        end,
      }
    end,
    dependencies = {
      "williamboman/mason.nvim"
    }
  }
}
