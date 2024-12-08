local my_default_lsp = {
  -- "lua_ls",
  -- "gopls",
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

      lsp_defaults.capabilities = require("blink.cmp").get_lsp_capabilities(lsp_defaults.capabilities)
      require("mason-lspconfig").setup_handlers {

        function(server_name) -- default handler
          lspconfig[server_name].setup({})
        end,
        ["beancount"] = function()
          lspconfig["beancount"].setup(require("user.plugins.lsp.configs.beancount"))
        end,
        ["gopls"] = function()
          lspconfig["gopls"].setup(require("user.plugins.lsp.configs.gopls"))
        end,
        ["terraformls"] = function()
          lspconfig["terraformls"].setup(require("user.plugins.lsp.configs.terraformls"))
        end,
        ["tflint"] = function()
          lspconfig["tflint"].setup(require("user.plugins.lsp.configs.tflint"))
        end,
        ["jsonnet_ls"] = function()
          lspconfig["jsonnet_ls"].setup(require("user.plugins.lsp.configs.jsonnet_ls"))
        end,
      }
    end,
    dependencies = {
      "williamboman/mason.nvim",
      'saghen/blink.cmp'
    }
  }
}
