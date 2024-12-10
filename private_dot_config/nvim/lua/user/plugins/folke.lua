---@type LazySpec
return {
  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
      library = {
        "lazy.nvim",
        { path = "snacks.nvim",        words = { "Snacks" } },
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },

  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {},
    -- stylua: ignore
    keys = {
      {
        "\\",
        mode = { "n", "x", "o" },
        function() require("flash").jump() end,
        desc = "Flash"
      },
      {
        "|",
        mode = { "n", "o", "x" },
        function() require("flash").treesitter() end,
        desc = "Flash Treesitter"
      },
      {
        "r",
        mode = "o",
        function() require("flash").remote() end,
        desc = "Remote Flash"
      },
      {
        "R",
        mode = { "o", "x" },
        function() require("flash").treesitter_search() end,
        desc = "Treesitter Search"
      },
      {
        "<c-\\>",
        mode = { "c" },
        function() require("flash").toggle() end,
        desc = "Toggle Flash Search"
      },
    },
  },

  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 400
    end,
    opts = {
      spec = {
        { "<leader>s",  group = "search" },
        { "<leader>g",  group = "git" },
        { "<leader>gd", group = "diff" },
        { "<leader>gb", group = "blame" },
        { "<leader>c",  group = "config" },
        { "<leader>h",  group = "hunk/highlight" },
        { "<leader>l",  group = "lsp" },
        { "<leader>r",  group = "rename" },
        { "<leader>w",  group = "workspace" },
        -- mini.ai custom objects
        {
          mode = { "x", "o" },
          { "id", desc = "digits" },
          { "ad", desc = "digits" },
          { "ie", desc = "case aware word" },
          { "ae", desc = "case aware word" },
        }
      },
    },
    config = true,
    dependencies = { "echasnovski/mini.icons" },
  },

  {
    "folke/noice.nvim",
    event = "VeryLazy",
    keys = {
      {
        "<Esc>",
        function()
          require("noice.message.router").dismiss()
        end,
        desc = "Dismiss noice popups"
      }
    },
    opts = {
      lsp = {
        -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          -- ["cmp.entry.get_documentation"] = true,
        },
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
      }
    },
    dependencies = {
      "MunifTanjim/nui.nvim",
    }
  },

  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      bigfile = { enabled = true },
      bufdelete = { enabled = true },
      dashboard = {
        enabled = true,
        preset = {
          keys = {
            { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
            { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
            { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
            { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
            {
              icon = " ",
              key = "c",
              desc = "Config",
              action = function()
                require("workspaces").open("nvim")
              end
            },
            { icon = "󱉥 ", key = "w", desc = "Workspaces", action = function() require('telescope').extensions.workspaces.workspaces() end },
            { icon = " ", key = "s", desc = "Restore Session", section = "session" },
            { icon = "󰒲 ", key = "L", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
            { icon = " ", key = "q", desc = "Quit", action = ":qa" },
          },
        },
      },
      gitbrowse = {
        remote_patterns = {
          -- ghcustom:foo/bar.git
          { "^gh%w+:(.+)%.git$",     "https://github.com/%1" },
          -- foo.bar.baz:foo/bar.git
          { "^([%w%.]+):(.+)%.git$", "https://%1/%2" },
        },
        url_patterns = {
          -- forgejo/gitea
          ["git%.mythoranium%.com"] = {
            branch = "/src/branch/{branch}",
            file = "/src/branch/{branch}/{file}#L{line_start}-L{line_end}",
            commit = "/commit/{commit}",
          },
        },
      },
      notifier = {
        enabled = true,
        timeout = 3000,
      },
      quickfile = { enabled = true },
      statuscolumn = { enabled = true },
      words = { enabled = true },
      styles = {
        notification = {
          wo = { wrap = true } -- Wrap notifications
        }
      }
    },
    keys = {
      { "<leader>o",   function() Snacks.bufdelete.delete() end,        desc = "Delete Buffer" },
      { "<leader>bd",  function() Snacks.bufdelete.all() end,           desc = "Delete All Buffers" },
      { "<leader>bo",  function() Snacks.bufdelete.other() end,         desc = "Delete All Other Buffers" },

      { "<leader>.",   function() Snacks.scratch() end,                 desc = "Toggle Scratch Buffer" },
      { "<leader>S",   function() Snacks.scratch.select() end,          desc = "Select Scratch Buffer" },
      { "<leader>n",   function() Snacks.notifier.show_history() end,   desc = "Notification History" },
      { "<leader>cR",  function() Snacks.rename.rename_file() end,      desc = "Rename File" },
      { "<leader>gB",  function() Snacks.gitbrowse() end,               desc = "Git Browse" },
      { "<leader>gbl", function() Snacks.git.blame_line() end,          desc = "Git Blame Line" },
      { "<leader>gf",  function() Snacks.lazygit.log_file() end,        desc = "Lazygit Current File History" },
      { "<leader>gg",  function() Snacks.lazygit() end,                 desc = "Lazygit" },
      { "<leader>gl",  function() Snacks.lazygit.log() end,             desc = "Lazygit Log (cwd)" },
      { "<leader>un",  function() Snacks.notifier.hide() end,           desc = "Dismiss All Notifications" },
      { "<c-/>",       function() Snacks.terminal() end,                desc = "Toggle Terminal" },
      { "<c-_>",       function() Snacks.terminal() end,                desc = "which_key_ignore" },
      { "]]",          function() Snacks.words.jump(vim.v.count1) end,  desc = "Next Reference",              mode = { "n", "t" } },
      { "[[",          function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev Reference",              mode = { "n", "t" } }
    },
    init = function()
      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        callback = function()
          -- Setup some globals for debugging (lazy-loaded)
          _G.dd = function(...)
            Snacks.debug.inspect(...)
          end
          _G.bt = function()
            Snacks.debug.backtrace()
          end
          vim.print = _G.dd -- Override print to use snacks for `:=` command

          -- Create some toggle mappings
          Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
          Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
          Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
          Snacks.toggle.diagnostics():map("<leader>ud")
          Snacks.toggle.line_number():map("<leader>ul")
          Snacks.toggle.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 }):map(
            "<leader>uc")
          Snacks.toggle.treesitter():map("<leader>uT")
          Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<leader>ub")
          Snacks.toggle.inlay_hints():map("<leader>uh")
        end,
      })
    end,
    dependencies = { "echasnovski/mini.icons" },
  },

  {
    "folke/todo-comments.nvim",
    cmd = { "TodoTrouble", "TodoTelescope" },
    event = { "BufReadPost", "BufNewFile" },
    config = true,
    -- stylua: ignore
    keys = {
      { "]t",         function() require("todo-comments").jump_next() end, desc = "Next todo comment" },
      { "[t",         function() require("todo-comments").jump_prev() end, desc = "Previous todo comment" },
      { "<leader>xt", "<cmd>TodoTrouble<cr>",                              desc = "Todo (Trouble)" },
      { "<leader>xT", "<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>",      desc = "Todo/Fix/Fixme (Trouble)" },
      { "<leader>st", "<cmd>TodoTelescope<cr>",                            desc = "Todo" },
      { "<leader>sT", "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>",    desc = "Todo/Fix/Fixme" },
    },
  },

  {
    "folke/twilight.nvim",
    keys = {
      { "<leader>hw", function() require("twilight").toggle() end, desc = "Toggle Twilight" },
    },
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    }
  },
}
