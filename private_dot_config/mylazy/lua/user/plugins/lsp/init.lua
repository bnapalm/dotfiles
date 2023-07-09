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

local global_keymaps = function()
  local nmap = function(lhs, rhs)
    local opts = { noremap = true, silent = true }
    vim.keymap.set('n', lhs, rhs, opts)
  end

  nmap('gl', vim.diagnostic.open_float)         -- Show diagnostics in a floating window
  nmap('[d', vim.diagnostic.goto_prev)          -- Move to the previous diagnostic
  nmap(']d', vim.diagnostic.goto_next)          -- Move to the next diagnostic
  nmap('<leader>d', vim.diagnostic.setloclist)  -- TODO check other options
end

local buffer_keymaps = function(bufnr)
  local bufmap = function(mode, lhs, rhs)
    local opts = { noremap = true, silent = true, buffer = bufnr }
    vim.keymap.set(mode, lhs, rhs, opts)
  end

  local t_builtin = require("telescope.builtin")

  -- Jump to declaration
  bufmap('n', 'gD', vim.lsp.buf.declaration)

  -- Jump to the definition
  bufmap('n', 'gd', t_builtin.lsp_definitions)

  -- Lists all the references
  bufmap('n', 'gr', t_builtin.lsp_references)

  -- Lists all the implementations for the symbol under the cursor
  bufmap('n', 'gi', t_builtin.lsp_implementations)

  -- Jumps to the definition of the type symbol
  bufmap('n', 'go', t_builtin.lsp_type_definitions)

  -- Displays hover information about the symbol under the cursor
  bufmap('n', 'K', vim.lsp.buf.hover)

  -- Displays a function's signature information
  bufmap({ 'n', 'i' }, '<C-k>', vim.lsp.buf.signature_help)

  -- Renames all references to the symbol under the cursor
  bufmap('n', '<leader>rn', vim.lsp.buf.rename)
  bufmap('n', '<F2>', '<leader>rn')

  -- Selects a code action available at the current cursor position
  bufmap({ 'n', 'v' }, '<F4>', vim.lsp.buf.code_action)

  bufmap("n", "<leader>lg", t_builtin.lsp_document_symbols)
  bufmap("n", "<leader>lc", t_builtin.lsp_dynamic_workspace_symbols)
  bufmap({ 'n', 'v' }, "<leader>lf", function() vim.lsp.buf.format({ async = true }) end)
  bufmap('n', '<space>wa', vim.lsp.buf.add_workspace_folder)
  bufmap('n', '<space>wr', vim.lsp.buf.remove_workspace_folder)
  bufmap('n', '<space>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end)
end

local M = {
  {
    "neovim/nvim-lspconfig",
    config = function()
      require("lspconfig").lua_ls.setup({
        settings = {
          Lua = {
            diagnostics = {
              globals = { 'vim' },
            },
            telemetry = {
              enable = false,
            },
          }
        }
      })

      global_keymaps()

      api.nvim_create_autocmd('LspAttach', {
        desc = "LSP actions",
        group = api.nvim_create_augroup('UserLspConfig', {}),
        callback = function(args)
          local bufnr = args.buf
          local client = vim.lsp.get_client_by_id(args.data.client_id)

          highlighting(client, bufnr)
          buffer_keymaps(bufnr)
        end
      })
    end,
    dependencies = {
      "nvim-telescope/telescope.nvim",
    }
  }
}

return M
