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
    "nvim-treesitter/nvim-treesitter",
    event = { 'BufReadPost', 'BufNewFile' },
    build = function()
      require("nvim-treesitter.install").update({ with_sync = true })
    end,
    config = function()
      local configs = require("nvim-treesitter.configs")

      configs.setup({
        ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "javascript", "typescript", "html", "rust", "bash",
          "beancount", "cpp", "dockerfile", "go", "godot_resource", "gomod", "gosum", "gowork", "git_config",
          "git_rebase", "gitcommit", "jq", "json", "json5", "jsonnet", "make", "markdown", "norg", "python", "regex",
          "sql", "terraform", "yaml" },
        sync_install = false,
        auto_install = true,
        highlight = { enable = true },
        indent = { enable = true },
        context_commentstring = {
          enable = true,
        },
        playground = {
          enable = true
        },
      })
    end,
    dependencies = {
      'JoosepAlviste/nvim-ts-context-commentstring'
    }
  },

  {
    "nvim-treesitter/playground",
    cmd = "TSPlaygroundToggle",
    dependencies = {
      'nvim-treesitter/nvim-treesitter'
    }
  },

  {
    "mbbill/undotree",
    keys = {
      { "<leader>u", vim.cmd.UndotreeToggle, desc = "Toggle Undotree" }
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
      require("nvim-autopairs").setup(opts)
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      local cmp = require("cmp")
      cmp.event:on(
        "confirm_done",
        cmp_autopairs.on_confirm_done()
      )
    end
  },

  {
    "numToStr/Comment.nvim",
    config = true,
  },

  {
    "ahmedkhalf/project.nvim",
    lazy = false,
    keys = {
      {
        '<leader>fp',
        function()
          require('telescope').extensions.projects.projects()
        end,
        desc = "Projects"
      }
    },
    config = function()
      require("project_nvim").setup {}
      require('telescope').load_extension('projects')
    end,
    dependencies = {
      'nvim-telescope/telescope.nvim'
    }
  },

  {
    "folke/neodev.nvim",
    lazy = true,
    config = true
  },

  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {},
    -- stylua: ignore
    keys = {
      {
        "\\",
        mode = { "n", "x", "o" },
        function() require("flash").jump() end,
        desc = "Flash"
      },
      {
        "|",
        mode = { "n", "o", "x" },
        function() require("flash").treesitter() end,
        desc = "Flash Treesitter"
      },
      {
        "r",
        mode = "o",
        function() require("flash").remote() end,
        desc = "Remote Flash"
      },
      {
        "R",
        mode = { "o", "x" },
        function() require("flash").treesitter_search() end,
        desc = "Treesitter Search"
      },
      {
        "<c-\\>",
        mode = { "c" },
        function() require("flash").toggle() end,
        desc = "Toggle Flash Search"
      },
    },
  },

  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 500
    end,
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)
      wk.register({
        ["<leader>f"] = { name = "+find" },
        ["<leader>g"] = { name = "+git" },
        ["<leader>c"] = { name = "+config" },
        ["<leader>h"] = { name = "+hunk/highlight" },
        ["<leader>l"] = { name = "+lsp" },
        ["<leader>r"] = { name = "+rename" },
      })
    end,
  }
}
