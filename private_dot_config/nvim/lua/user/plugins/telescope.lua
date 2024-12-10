local ivy_opts = {
  theme = "ivy",
  layout_config = { height = 0.80 },
}

return {
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    cmd = "Telescope",
    keys = {
      {
        "<leader>sf",
        require('telescope.builtin').find_files,
        desc = "Find Files",
      },
      {
        "<leader>sc",
        require('telescope.builtin').grep_string,
        desc = "Grep word under cursor",
      },
      {
        "<leader>sg",
        require('telescope.builtin').live_grep,
        desc = "Live Grep",
      },
      {
        "<leader>sb",
        require('telescope.builtin').buffers,
        desc = "Buffers",
      },
      {
        "<leader>s/",
        require('telescope.builtin').current_buffer_fuzzy_find,
        desc = "Find in current buffer",
      },
      {
        "<leader>sB",
        require('telescope.builtin').git_branches,
        desc = "Find branches (Telescope)",
      },
    },
    opts = {
      pickers = {
        find_files = ivy_opts,
        grep_string = ivy_opts,
        live_grep = ivy_opts,
      },
      extensions = {
        fzf = {
          fuzzy = true,
          override_generic_sorter = true,
          override_file_sorter = true,
          case_mode = "smart_case",
        },
      },
    },
    config = function(_, opts)
      require("telescope").setup(opts)
      require("telescope").load_extension('fzf')
    end,
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = "make"
      },
    }
  },
}
