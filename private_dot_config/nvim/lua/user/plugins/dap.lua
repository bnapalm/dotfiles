return {
  {
    "mfussenegger/nvim-dap",
    lazy = true,
    keys = {
      {
        "<leader>db",
        function() require("dap").toggle_breakpoint() end,
        desc = "Toggle Breakpoint"
      },

      {
        "<leader>dc",
        function() require("dap").continue() end,
        desc = "Continue"
      },

      {
        "<leader>dC",
        function() require("dap").run_to_cursor() end,
        desc = "Run to Cursor"
      },

      {
        "<leader>dT",
        function() require("dap").terminate() end,
        desc = "Terminate"
      },

      {
        "<F6>",
        function() require("dap").step_over() end,
        desc = "Step into"
      },

      {
        "<F7>",
        function() require("dap").step_into() end,
        desc = "Step into"
      },

      {
        "<F8>",
        function() require("dap").step_out() end,
        desc = "Step into"
      },
    },

    -- config = function ()
    --   local dap = require("dap")
    --   dap.adapters.jsonnet = {
    --     name = "jsonnet";
    --     type = "executable";
    --     command = "jsonnet-debugger";
    --     args = {"-s"};
    --   }
    -- end
  },

  {
    "leoluz/nvim-dap-go",
    config = true,
    dependencies = {
      "mfussenegger/nvim-dap",
    },
    keys = {
      {
        "<leader>dt",
        function() require('dap-go').debug_test() end,
        desc = "Debug test"
      },
    },
  },

  {
    "theHamsta/nvim-dap-virtual-text",
    config = true,
    dependencies = {
      "mfussenegger/nvim-dap",
    },
  },

  {
    "rcarriga/nvim-dap-ui",
    config = true,
    keys = {
      {
        "<leader>du",
        function()
          require("dapui").toggle({})
        end,
        desc = "Dap UI"
      },
    },
    dependencies = {
      -- "jay-babu/mason-nvim-dap.nvim",
      "leoluz/nvim-dap-go",
      -- "mfussenegger/nvim-dap-python",
      "nvim-neotest/nvim-nio",
      "theHamsta/nvim-dap-virtual-text",
    },
  },

  {
    "nvim-neotest/nvim-nio",
  },
}
