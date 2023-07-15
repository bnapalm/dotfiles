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
    "moll/vim-bbye",
    cmd = "Bdelete",
    keys = {
      { "<leader>x", "<cmd>Bdelete<cr>", desc = "Delete buffer" }
    }
  },

  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v2.x",
    keys = {
      { "<leader>ft", "<cmd>Neotree toggle<cr>", desc = "NeoTree" },
    },
    opts = {
      sync_root_with_cwd = true,
      respect_buf_cwd = true,
      update_focused_file = {
        enable = true,
        update_root = true
      }
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
    }
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
  --
  -- better text-objects
  {
    "echasnovski/mini.ai",
    event = "VeryLazy",
    dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
    opts = function()
      local ai = require("mini.ai")
      return {
        n_lines = 500,
        custom_textobjects = {
          o = ai.gen_spec.treesitter({
            a = { "@block.outer", "@conditional.outer", "@loop.outer" },
            i = { "@block.inner", "@conditional.inner", "@loop.inner" },
          }, {}),
          f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }, {}),
          c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }, {}),
        },
      }
    end,
  },

  {
    'echasnovski/mini.indentscope',
    version = false,
    opts = function()
      local indentscope = require("mini.indentscope")
      return {
        symbol = "│",
        draw = {
          animation = indentscope.gen_animation.quadratic({
            -- easing = "in",
            duration = 10
          })
        },
        options = { try_as_border = true },
      }
    end,
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = {
          "help",
          "alpha",
          "dashboard",
          "neo-tree",
          "Trouble",
          "lazy",
          "mason",
          "notify",
          "toggleterm",
          "lazyterm",
        },
        callback = function()
          vim.b.miniindentscope_disable = true
        end,
      })
    end,
  },

  {
    'echasnovski/mini.surround',
    version = false,
    config = true,
    keys = {
      { 'sa', desc = "Add surrounding in Normal and Visual modes", mode = { "n", "v" } },
      { 'sd', desc = "Delete surrounding" },
      { 'sf', desc = "Find surrounding (to the right)" },
      { 'sF', desc = "Find surrounding (to the left)" },
      { 'sh', desc = "Highlight surrounding" },
      { 'sr', desc = "Replace surrounding" },
      { 'sn', desc = "Update `n_lines`" },
    }
  },

  {
    'echasnovski/mini.tabline',
    version = false,
    config = true
  },
}
