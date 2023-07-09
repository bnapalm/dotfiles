return {
  -- the colorscheme should be available when starting Neovim
  {
    "luisiacc/gruvbox-baby",
    lazy = false,    -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      -- load the colorscheme here
      vim.cmd([[colorscheme gruvbox-baby]])
    end,
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v2.x",
    keys = {
      { "<leader>ft", "<cmd>Neotree toggle<cr>", desc = "NeoTree" },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
    }
  },
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim'
    }
  },
  {
    "nvim-treesitter/nvim-treesitter",
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
      })
    end
  },
  {
    "mbbill/undotree",
    keys = {
      { "<leader>u", vim.cmd.UndotreeToggle, desc = "Toggle Undotree" }
    }
  },
  {
    "tpope/vim-fugitive",
    cmd = "Git",
    keys = {
      { "<leader>gs", vim.cmd.Git, desc = "FuGitive Status" }
    }
  },
}
