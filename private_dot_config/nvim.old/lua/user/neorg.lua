local status_ok, neorg = pcall(require, "neorg")
if not status_ok then
  return
end

neorg.setup {
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
}
