local api = vim.api

local function highlighting(client, bufnr)
  if client.server_capabilities.documentHighlightProvider then
    local lsp_highlight_grp = api.nvim_create_augroup("LspDocumentHighlight", { clear = true })
    api.nvim_create_autocmd("CursorHold", {
      callback = function()
        vim.schedule(vim.lsp.buf.document_highlight)
      end,
      group = lsp_highlight_grp,
      buffer = bufnr,
    })
    api.nvim_create_autocmd("CursorMoved", {
      callback = function()
        vim.schedule(vim.lsp.buf.clear_references)
      end,
      group = lsp_highlight_grp,
      buffer = bufnr,
    })
  end
end

local M = {
  {
    import = "user.plugins.lsp.mason"
  },
  {
    "neovim/nvim-lspconfig",
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      local keymaps = require("user.plugins.lsp.keymaps")
      local lspconfig = require("lspconfig")

      api.nvim_create_autocmd('LspAttach', {
        desc = "LSP actions",
        group = api.nvim_create_augroup('UserLspConfig', {}),
        callback = function(args)
          local bufnr = args.buf
          local client = vim.lsp.get_client_by_id(args.data.client_id)

          highlighting(client, bufnr)
          keymaps.buflocal(bufnr)
        end
      })

      -- lspconfig["lua_ls"].setup(require("user.plugins.lsp.configs.lua_ls"))
      lspconfig["lua_ls"].setup {}
      lspconfig["nixd"].setup(require("user.plugins.lsp.configs.nixd"))
      lspconfig["pyright"].setup {}
      lspconfig["yamlls"].setup {}
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
