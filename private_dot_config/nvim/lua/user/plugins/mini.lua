return {
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
    -- following don't actually define keymaps,
    -- just activate lazy-loading
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

  {
    'echasnovski/mini.bracketed',
    version = false,
    config = true
  },

  {
    'echasnovski/mini.splitjoin',
    version = false,
    keys = {
      { 'gS', desc = "Toggle splitjoint line" }
    },
    config = true
  },

  {
    'echasnovski/mini.bufremove',
    version = false,
    keys = {
      {
        "<leader>o",
        function()
          require("mini.bufremove").delete()
        end,
        desc = "Delete buffer"
      }
    },
    config = true
  },

}
