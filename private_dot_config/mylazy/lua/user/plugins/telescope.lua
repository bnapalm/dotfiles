return {
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    cmd = "Telescope",
    keys = {
      {
        "<leader>tf",
        function()
          require('telescope.builtin').find_files()
        end,
        desc = "Telescope: Find Files",
      },
      {
        "<leader>tt",
        function()
          require('telescope.builtin').live_grep()
        end,
        desc = "Telescope: Live Grep",
      },
      {
        "<leader>tb",
        function()
          require('telescope.builtin').buffers()
        end,
        desc = "Telescope: Buffers",
      },
      {
        "<leader>t/",
        function()
          require('telescope.builtin').current_buffer_fuzzy_find()
        end,
        desc = "Telescope: Find in current buffer",
      },
    },
    dependencies = {
      'nvim-lua/plenary.nvim'
    }
  },
}
