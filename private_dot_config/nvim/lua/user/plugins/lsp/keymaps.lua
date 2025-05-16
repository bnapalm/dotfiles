local M = {}

M.buflocal = function(bufnr)
  local bufmap = function(mode, lhs, rhs, desc)
    local opts = { noremap = true, silent = true, buffer = bufnr }
    if desc then opts.desc = desc end
    vim.keymap.set(mode, lhs, rhs, opts)
  end

  -- local t_builtin = require("telescope.builtin")
  local trouble = require("trouble")

  -- Jump to declaration
  -- bufmap('n', 'gD', vim.lsp.buf.declaration, "GoTo Declaration")

  -- Jump to the definition
  bufmap('n', 'gd', function() trouble.open("lsp_definitions") end, "GoTo Definition")

  -- Lists all the references
  -- bufmap('n', 'gr', function() trouble.open("lsp_references") end, "List References")

  -- Lists all the implementations for the symbol under the cursor
  -- bufmap('n', 'gi', t_builtin.lsp_implementations, "List Implementations")

  -- Jumps to the definition of the type symbol
  bufmap('n', 'go', function() trouble.open("lsp_type_definitions") end, "GoTo Type Definition")

  -- Displays hover information about the symbol under the cursor
  -- bufmap('n', 'K', vim.lsp.buf.hover, "Hover Info")

  -- Displays a function's signature information
  bufmap({ 'n', 'i', 's' }, '<C-k>', vim.lsp.buf.signature_help, "Show Signature Help")

  -- Renames all references to the symbol under the cursor
  -- bufmap('n', '<leader>rn', vim.lsp.buf.rename, "LSP Rename")
  -- bufmap('n', '<F2>', '<leader>rn')

  -- Selects a code action available at the current cursor position
  -- bufmap({ 'n', 'v' }, '<F4>', vim.lsp.buf.code_action, "Execute Code Action")

  -- now gO
  -- bufmap("n", "<leader>lg", t_builtin.lsp_document_symbols, "List Document Symbols")
  -- bufmap("n", "<leader>lc", t_builtin.lsp_dynamic_workspace_symbols, "List Workspace Symbols")
  bufmap({ 'n', 'v' }, "<leader>lf", function() vim.lsp.buf.format({ async = true }) end, "Format")
  -- bufmap('n', '<space>wa', vim.lsp.buf.add_workspace_folder, "Add Workspace Folder")
  -- bufmap('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, "Remove Workspace Folder")
  -- bufmap('n', '<space>wl', function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, "List Workspace Folders")
end

return M
