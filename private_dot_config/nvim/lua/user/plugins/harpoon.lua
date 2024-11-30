local function harpoonToFile(num)
  require("harpoon"):list():select(num)
end

return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  config = true,

  keys = {
    {
      "<leader>a",
      function()
        require("harpoon"):list():add()
      end,
      desc = "Add file to Harpoon",
    },
    {
      "<C-e>",
      function()
        local harpoon = require("harpoon")
        harpoon.ui:toggle_quick_menu(harpoon:list())
      end,
      desc = "Toggle Harpoon menu",
    },
    {
      "<C-h>",
      harpoonToFile(1),
      desc = "Harpoon to file 1",
    },
    {
      "<C-t>",
      harpoonToFile(2),
      desc = "Harpoon to file 2",
    },
    {
      "<C-s>",
      harpoonToFile(3),
      desc = "Harpoon to file 3",
    },
    {
      "<C-n>",
      harpoonToFile(4),
      desc = "Harpoon to file 4",
    },
  },

  dependencies = { "nvim-lua/plenary.nvim"}
}
