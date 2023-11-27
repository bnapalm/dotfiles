return {

  {
    "nvim-treesitter/nvim-treesitter",
    event = { 'BufReadPost', 'BufNewFile' },
    build = function()
      require("nvim-treesitter.install").update({ with_sync = true })
    end,
    config = function()
      local configs = require("nvim-treesitter.configs")

      -- disable legacy commentstring
      vim.g.skip_ts_context_commentstring_module = true

      configs.setup({
        ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "javascript", "typescript", "html", "rust", "bash",
          "beancount", "cpp", "dockerfile", "go", "godot_resource", "gomod", "gosum", "gowork", "git_config",
          "git_rebase", "gitcommit", "jq", "json", "json5", "jsonnet", "make", "markdown", "norg", "python", "regex",
          "sql", "terraform", "yaml" },
        sync_install = false,
        auto_install = true,
        highlight = { enable = true },
        indent = { enable = true },
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
    "nvim-treesitter/nvim-treesitter-context",
    event = { 'BufReadPost', 'BufNewFile' },
    cmd = { "TSContextEnable", "TSContextDisable", "TSContextToggle" },
    keys = { "<leader>hc", "<cmd>TSContextToggle<cr>", desc = "Toggle Treesitter context" },
    config = true,
  },

}
