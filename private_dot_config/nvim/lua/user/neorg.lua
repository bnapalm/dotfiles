local status_ok, neorg = pcall(require, "neorg")
if not status_ok then
  return
end

neorg.setup {
  load = {
    ["core.defaults"] = {},
    ["core.norg.dirman"] = {
      config = {
        workspaces = {
          work = "~/src/notes/work",
          home = "~/src/notes/home",
        }
      }
    },
    ["core.norg.concealer"] = {
      config = {
        preset = "varied",
        markup_preset = "safe"
      }
    },
    ["core.norg.completion"] = {
      config = {
        engine = "nvim-cmp"
      }
    }
  }
}
