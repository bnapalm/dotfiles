return {
  'MeanderingProgrammer/render-markdown.nvim',
  opts = {
    heading = {
      width = 'block',
      right_pad = 1,
    },
    code = {
      sign = false,
      width = 'block',
      left_pad = 2,
      right_pad = 2,
      min_width = 40,
    },
    indent = {
      enabled = true,
    },
  },
  -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.nvim' }, -- if you use the mini.nvim suite
  -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
  dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
}
