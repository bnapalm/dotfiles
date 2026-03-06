---@type LazySpec
return {
  -- the colorscheme should be available when starting Neovim
  {
    "ellisonleao/gruvbox.nvim",
    lazy = false,    -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    init = function()
      vim.o.background = "dark"
    end,
    config = function()
      -- load the colorscheme here
      vim.cmd([[colorscheme gruvbox]])
    end,
  },

  {
    "mbbill/undotree",
    keys = {
      { "<leader>uu", vim.cmd.UndotreeToggle, desc = "Toggle Undotree" }
    }
  },

  {
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    opts = {
      check_ts = true,
      ts_config = {
        lua = { 'string' }, -- it will not add a pair on that treesitter node
        javascript = { 'template_string' },
        java = false,       -- don't check treesitter on java
      },
      fast_wrap = {},
    },
    config = function(_, opts)
      local npairs = require('nvim-autopairs')
      local Rule = require('nvim-autopairs.rule')

      local function currentNixNodeType(bufnr, row, col)
        local parser = vim.treesitter.get_parser(bufnr, 'nix', { error = false })
        if parser == nil then
          return nil
        end

        parser:parse()

        local node = vim.treesitter.get_node({
          bufnr = bufnr,
          pos = { row, math.max(col - 1, 0) },
          ignore_injections = false,
        })

        return node
      end

      local function hasForbiddenNixAncestor(node)
        local forbidden = {
          interpolation = true,
          string_expression = true,
          indented_string_expression = true,
        }

        while node do
          if forbidden[node:type()] then
            return true
          end
          node = node:parent()
        end

        return false
      end

      local function isOnlyFollowedByWhitespace(opts)
        local suffix = opts.line:sub(opts.col)
        return suffix == '' or suffix:match('^%s+$') ~= nil
      end

      local function shouldTerminateNixCollection(opts)
        if not isOnlyFollowedByWhitespace(opts) then
          return false
        end

        local row = vim.api.nvim_win_get_cursor(0)[1] - 1
        local node = currentNixNodeType(opts.bufnr, row, opts.col)
        if node == nil then
          return true
        end

        return not hasForbiddenNixAncestor(node)
      end

      npairs.setup(opts)
      npairs.add_rules({
        Rule('{', '};', 'nix'):with_pair(shouldTerminateNixCollection),
        Rule('[', '];', 'nix'):with_pair(shouldTerminateNixCollection),
      })
    end
  },

  {
    'rcarriga/nvim-notify',
    lazy = true,
    config = true,
  },

  {
    "ray-x/go.nvim",
    config = function()
      local capabilities = require('blink.cmp').get_lsp_capabilities(vim.lsp.protocol.make_client_capabilities())
      require('go').setup({
        lsp_cfg = {
          capabilities = capabilities,
        },
        lsp_keymaps = false,
        lsp_inlay_hints = {
          enable = false,
        },
        lsp_on_client_start = function(_, bufnr)
          -- go.nvim overrides some keymaps, but we don't want to disable all provided ones,
          -- so we override with my default keymaps again
          require("user.plugins.lsp.keymaps").buflocal(bufnr)
        end,
        luasnip = true,
        trouble = true
      })
    end,
    event = { "CmdlineEnter" },
    ft = { "go", 'gomod' },
    build = ':lua require("go.install").update_all_sync()', -- if you need to install/update all binaries
    dependencies = {                                        -- optional packages
      "ray-x/guihua.lua",
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
      -- "hrsh7th/nvim-cmp",
    },
  },

  {
    'mikesmithgh/kitty-scrollback.nvim',
    enabled = true,
    lazy = true,
    cmd = { 'KittyScrollbackGenerateKittens', 'KittyScrollbackCheckHealth' },
    event = { 'User KittyScrollbackLaunch' },
    -- version = '*', -- latest stable version, may have breaking changes if major version changed
    -- version = '^2.0.0', -- pin major version, include fixes and features that do not have breaking changes
    config = function()
      require('kitty-scrollback').setup()
    end,
  },

}
