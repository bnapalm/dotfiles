return {
  "nvim-neorg/neorg",
  cmd = "Neorg",
  ft = "norg",
  opts = {
    load = {
      ["core.defaults"] = {},
      ["core.concealer"] = {},
      ["core.dirman"] = {
        config = {
          workspaces = {
            work = "~/src/notes/work",
            home = "~/src/notes/home",
          },
          default_workspace = "home",
        }
      },
      ["core.summary"] = {},
      ["core.completion"] = {
        config = {
          engine = "nvim-cmp"
        }
      }
    }
  },
  dependencies = {
    "nvim-lua/plenary.nvim"
  }
}
