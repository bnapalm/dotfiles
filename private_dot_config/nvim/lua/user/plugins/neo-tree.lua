return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  keys = {
    { "<leader>t", "<cmd>Neotree toggle reveal_force_cwd<cr>", desc = "NeoTree" },
  },
  cmd = "Neotree",
  opts = {
    window = {
      mappings = {
        ["h"] = "close_node",
        ["l"] = "open",
      }
    },
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",   -- not strictly required, but recommended
    "MunifTanjim/nui.nvim",
  }
}
