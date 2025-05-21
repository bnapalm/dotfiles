local api = vim.api

local M = {
  {
    import = "user.plugins.lsp.mason"
  },
  {
    "neovim/nvim-lspconfig",
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      local keymaps = require("user.plugins.lsp.keymaps")
      local trouble = require("trouble")
      local t_builtin = require("telescope.builtin")

      -- Lists all the references
      vim.keymap.del("n", "grr")
      vim.keymap.set("n", "grr", function() trouble.open("lsp_references") end, { desc = "List References" })

      -- Lists all implementations
      vim.keymap.del("n", "gri")
      vim.keymap.set("n", "gri", function() trouble.open("lsp_implementations") end, { desc = "List Implementations" })

      -- Lists document symbols
      vim.keymap.del("n", "gO")
      vim.keymap.set("n", "gO", t_builtin.lsp_document_symbols, { desc = "Document Symbols" })

      vim.keymap.set('n', '<F2>', 'grn')
      vim.keymap.set({ 'n', 'v' }, '<F4>', vim.lsp.buf.code_action, { desc = "Execute Code Action" })

      api.nvim_create_autocmd('LspAttach', {
        desc = "LSP actions",
        group = api.nvim_create_augroup('UserLspConfig', {}),
        callback = function(args)
          local bufnr = args.buf
          keymaps.buflocal(bufnr)
        end
      })

      vim.lsp.config["nixd"] = require("user.plugins.lsp.configs.nixd")

      vim.lsp.enable({
        "lua_ls",
        "nixd",
        "yamlls",
      })
    end,

    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "folke/trouble.nvim"
    }
  },

  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = { "Trouble" },
    opts = {
      -- position = "right",
      use_diagnostic_signs = true,
      win = {
        size = 0.4
      },
    },
    keys = {
      {
        "<leader>xx",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "Diagnostics (Trouble)"
      },
      {
        "<leader>xX",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "Buffer Diagnostics (Trouble)"
      },
      {
        "<leader>xs",
        "<cmd>Trouble symbols toggle focus=false<cr>",
        desc = "Symbols (Trouble)"
      },
      {
        "<leader>xl",
        "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
        desc = "LSP Def / ref / ... (Trouble)"
      },
      {
        "<leader>xL",
        "<cmd>Trouble loclist toggle<cr>",
        desc = "Location List (Trouble)"
      },
      {
        "<leader>xq",
        "<cmd>Trouble qflist toggle<cr>",
        desc = "Quickfix List (Trouble)"
      },
      {
        "[q",
        function()
          if require("trouble").is_open() then
            require("trouble").previous({ skip_groups = true, jump = true })
          else
            local ok, err = pcall(vim.cmd.cprev)
            if not ok then
              vim.notify(err, vim.log.levels.ERROR)
            end
          end
        end,
        desc = "Previous trouble/quickfix item",
      },
      {
        "]q",
        function()
          if require("trouble").is_open() then
            require("trouble").next({ skip_groups = true, jump = true })
          else
            local ok, err = pcall(vim.cmd.cnext)
            if not ok then
              vim.notify(err, vim.log.levels.ERROR)
            end
          end
        end,
        desc = "Next trouble/quickfix item",
      },
    },
  },
}

return M
