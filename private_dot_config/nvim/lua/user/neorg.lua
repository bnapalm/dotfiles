local status_ok, neorg = pcall(require, "neorg")
if not status_ok then
  return
end

neorg.setup {
  load = {
    ["core.defaults"] = {},
    ["core.norg.esupports.indent"] = {
      config = {
        tweaks = {
          heading2 = 1,
          heading3 = 2,
          heading4 = 3,
          heading5 = 4,
          heading6 = 5,
          unordered_list2 = 1,
          unordered_list3 = 2,
          unordered_list4 = 3,
          unordered_list5 = 4,
          unordered_list6 = 5,
          ordered_list2 = 1,
          ordered_list3 = 2,
          ordered_list4 = 3,
          ordered_list5 = 4,
          ordered_list6 = 5,
          unordered_link2 = 1,
          unordered_link3 = 2,
          unordered_link4 = 3,
          unordered_link5 = 4,
          unordered_link6 = 5,
        }
      }
    },
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
        markup_preset = "safe",
        folds = "false"
      }
    },
    ["core.norg.completion"] = {
      config = {
        engine = "nvim-cmp"
      }
    }
  }
}
