return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  keys = {
    { "<leader>t", "<cmd>Neotree toggle reveal_force_cwd<cr>", desc = "NeoTree" },
  },
  cmd = "Neotree",
  opts = {
    sync_root_with_cwd = true,
    respect_buf_cwd = true,
    update_focused_file = {
      enable = true,
      update_root = true
    },
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
