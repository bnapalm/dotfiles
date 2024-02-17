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
    config = function()
      require("Comment").setup({
        pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
      })
    end,
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      'JoosepAlviste/nvim-ts-context-commentstring',
    },
  },

  -- {
  --   "ahmedkhalf/project.nvim",
  --   lazy = false,
  --   keys = {
  --     {
  --       '<leader>sp',
  --       function()
  --         require('telescope').extensions.projects.projects()
  --       end,
  --       desc = "Projects"
  --     }
  --   },
  --   opts = {
  --     detection_methods = { "pattern" },
  --   },
  --   config = function(_, opts)
  --     require("project_nvim").setup(opts)
  --     require('telescope').load_extension('projects')
  --   end,
  --   dependencies = {
  --     'nvim-telescope/telescope.nvim'
  --   }
  -- },

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
      vim.o.timeoutlen = 400
    end,
    opts = {
      triggers_nowait = {
        -- marks
        "`",
        "'",
        "g`",
        "g'",
        -- spelling
        "z=",
      },
    },
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)
      wk.register({
        ["<leader>s"] = { name = "+search" },
        ["<leader>g"] = { name = "+git" },
        ["<leader>c"] = { name = "+config" },
        ["<leader>h"] = { name = "+hunk/highlight" },
        ["<leader>l"] = { name = "+lsp" },
        ["<leader>r"] = { name = "+rename" },
        ["<leader>w"] = { name = "+workspace" },
      })
    end,
  },

  {
    'rcarriga/nvim-notify',
    lazy = true,
    config = true,
  },

  {
    "folke/noice.nvim",
    event = "VeryLazy",
    keys = {
      {
        "<Esc>",
        function()
          require("noice.message.router").dismiss()
        end,
        desc = "Dismiss noice popups"
      }
    },
    opts = {
      presets = {
        bottom_search = true,
        long_message_to_split = true,
      }
    },
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    }
  },

  {
    "folke/todo-comments.nvim",
    cmd = { "TodoTrouble", "TodoTelescope" },
    event = { "BufReadPost", "BufNewFile" },
    config = true,
    -- stylua: ignore
    keys = {
      { "]t",         function() require("todo-comments").jump_next() end, desc = "Next todo comment" },
      { "[t",         function() require("todo-comments").jump_prev() end, desc = "Previous todo comment" },
      { "<leader>xt", "<cmd>TodoTrouble<cr>",                              desc = "Todo (Trouble)" },
      { "<leader>xT", "<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>",      desc = "Todo/Fix/Fixme (Trouble)" },
      { "<leader>st", "<cmd>TodoTelescope<cr>",                            desc = "Todo" },
      { "<leader>sT", "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>",    desc = "Todo/Fix/Fixme" },
    },
  },


  {
    "ray-x/go.nvim",
    config = function()
      require("go").setup()
    end,
    event = { "CmdlineEnter" },
    ft = { "go", 'gomod' },
    build = ':lua require("go.install").update_all_sync()', -- if you need to install/update all binaries
    dependencies = {                                        -- optional packages
      "ray-x/guihua.lua",
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },
  },

  {
    "folke/twilight.nvim",
    keys = {
      { "<leader>hw", function() require("twilight").toggle() end, desc = "Toggle Twilight" },
    },
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    }
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
  }
}
