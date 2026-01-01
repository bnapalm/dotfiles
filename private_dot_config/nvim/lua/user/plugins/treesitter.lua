--- TODO: move table_except to separate lib
---
---@generic T
---@param super T[]
---@param sub T[]
---@return T[]
local table_except = function(super, sub)
  local result = {}
  local seenInResult = {}
  local lookupSub = {}

  for _, value in ipairs(sub) do
    lookupSub[value] = true
  end

  for _, value in ipairs(super) do
    if not lookupSub[value] and not seenInResult[value] then
      table.insert(result, value)
      seenInResult[value] = true
    end
  end

  return result
end

return {
  {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    branch = 'main',
    build = function()
      require("nvim-treesitter").update(nil, { summary = true })
    end,
    event = { "VeryLazy" },
    cmd = { "TSUpdate", "TSInstall", "TSLog", "TSUninstall" },
    opts_extend = { "ensure_installed" },
    opts = {
      indent = { enable = true },
      highlight = { enable = true },
      folds = { enable = true },
      ensure_installed = {
        "c", "lua", "vim", "vimdoc", "query", "javascript", "typescript",
        "html", "rust", "bash", "beancount", "cpp", "dockerfile", "go",
        "godot_resource", "gomod", "gosum", "gowork", "git_config",
        "git_rebase", "gitcommit", "jq", "json", "json5", "jsonnet", "make",
        "markdown", "markdown_inline", "norg", "python", "regex", "sql",
        "terraform", "yaml", "nix"
      },
    },
    config = function(_, opts)
      local ts = require("nvim-treesitter")

      -- setup treesitter
      ts.setup(opts)

      -- install missing parsers
      local install = table_except(opts.ensure_installed, ts.get_installed())
      if #install > 0 then
        ts.install(install, { summary = true })
      end

      vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup("lazyvim_treesitter", { clear = true }),
        callback = function(ev)
          local lang = vim.treesitter.language.get_lang(ev.match)

          if not vim.list_contains(ts.get_installed(), lang) then
            return
          end

          vim.treesitter.start(ev.buf)
        end,
      })
    end,
    dependencies = {
      'JoosepAlviste/nvim-ts-context-commentstring'
    }
  },

  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    branch = 'main',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
    },
    config = true,
    -- config = function()
    --   require('nvim-treesitter-textobjects').setup {
    --     select = {
    --       lookahead = true,
    --       selection_modes = {
    --         ['@parameter.outer'] = 'v',
    --         ['@function.outer'] = 'V',
    --         ['@class.outer'] = 'V',
    --       },
    --       include_surrounding_whitespace = true,
    --     },
    --     move = {
    --       set_jumps = false,
    --     },
    --   }
    --   do -- move
    --     vim.keymap.set({ 'n', 'x', 'o' }, ']]', function()
    --       require('nvim-treesitter-textobjects.move').goto_next_start(
    --         '@function.outer',
    --         'textobjects'
    --       )
    --       vim.cmd('normal! zz')
    --     end)
    --     vim.keymap.set({ 'n', 'x', 'o' }, '[[', function()
    --       require('nvim-treesitter-textobjects.move').goto_previous_start(
    --         '@function.outer',
    --         'textobjects'
    --       )
    --       vim.cmd('normal! zz')
    --     end)
    --   end
    -- end,
  },

  {
    'JoosepAlviste/nvim-ts-context-commentstring',
    opts = {
      enable_autocmd = false
    },
  },

  {
    "nvim-treesitter/nvim-treesitter-context",
    event = { 'BufReadPost', 'BufNewFile' },
    cmd = { "TSContextEnable", "TSContextDisable", "TSContextToggle" },
    keys = { "<leader>hc", "<cmd>TSContextToggle<cr>", desc = "Toggle Treesitter context" },
    config = true,
  },

}
