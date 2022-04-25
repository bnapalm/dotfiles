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
          work = "~/notes/work",
          home = "~/notes/home",
        }
      }
    },
    ["core.norg.concealer"] = {
      config = {}
    },
    ["core.norg.completion"] = {
      config = {
        engine = "nvim-cmp"
      }
    }
  }
}
