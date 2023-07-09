return {
  "theprimeagen/harpoon",
  keys = {
    {
      "<leader>a",
      function()
        require("harpoon.mark").add_file()
      end,
      desc = "Add file to Harpoon",
    },
    {
      "<C-e>",
      function()
        require("harpoon.ui").toggle_quick_menu()
      end,
      desc = "Toggle Harpoon menu",
    },
    {
      "<C-h>",
      function()
        require("harpoon.ui").nav_file(1)
      end,
      desc = "Harpoon to file 1",
    },
    {
      "<C-t>",
      function()
        require("harpoon.ui").nav_file(2)
      end,
      desc = "Harpoon to file 2",
    },
    {
      "<C-n>",
      function()
        require("harpoon.ui").nav_file(3)
      end,
      desc = "Harpoon to file 3",
    },
    {
      "<C-s>",
      function()
        require("harpoon.ui").nav_file(4)
      end,
      desc = "Harpoon to file 4",
    },
  }
}
