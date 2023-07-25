return {
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    cmd = "Telescope",
    keys = {
      {
        "<leader>ff",
        function()
          require('telescope.builtin').find_files()
        end,
        desc = "Find Files",
      },
      {
        "<leader>ft",
        function()
          require('telescope.builtin').live_grep()
        end,
        desc = "Live Grep",
      },
      {
        "<leader>fb",
        function()
          require('telescope.builtin').buffers()
        end,
        desc = "Buffers",
      },
      {
        "<leader>f/",
        function()
          require('telescope.builtin').current_buffer_fuzzy_find()
        end,
        desc = "Find in current buffer",
      },
    },
    opts = {
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
