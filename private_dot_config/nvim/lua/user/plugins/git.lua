return {

  {
    "sindrets/diffview.nvim",
    cmd = {
      "DiffviewOpen",
      "DiffviewFileHistory",
      "DiffviewClose",
    },
    keys = {
      { "<leader>gdo", vim.cmd.DiffviewOpen,        desc = "Diffview Open" },
      { "<leader>gdb", vim.cmd.DiffviewFileHistory, desc = "Diffview Branch" },
      { "<leader>gdq", vim.cmd.DiffviewClose,       desc = "Diffview Branch" },
      {
        "<leader>gdf",
        function()
          vim.cmd.DiffviewFileHistory({ "%" })
        end,
        desc = "Diffview File"
      },
    },
  },

  {
    "NeogitOrg/neogit",
    keys = {
      {
        "<leader>gs",
        function()
          require("neogit").open()
        end,
        desc = "Neogit Status"
      },
      {
        "<leader>gp",
        function()
          require("neogit").open({ "push" })
        end,
        desc = "NeoGit Push"
      },
      {
        "<leader>gl",
        function()
          require("neogit").open({ "pull" })
        end,
        desc = "NeoGit Pull"
      },
      {
        "<leader>gr",
        function()
          require("neogit").action("push", "push", "--set-upstream")
        end,
        desc = "NeoGit Push (with setting remote tracking)"
      },
    },
    opts = {
      kind = "auto",
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
      "nvim-telescope/telescope.nvim",
    },
  },

  {
    "tpope/vim-fugitive",
    cmd = {
      "Git",
      "G",
      "GBrowse"
    },
    keys = {
      --   { "<leader>gs", vim.cmd.Git, desc = "Fugitive Status" },
      {
        "<leader>gbw",
        function()
          vim.cmd.Git({ "blame -wCCC" })
        end,
        desc = "Git Blame (real changes)"
      },
      {
        "<leader>gbb",
        function()
          vim.cmd.Git({ "blame" })
        end,
        desc = "Git Blame (vanilla)"
      },
      --   {
      --     "<leader>gl",
      --     function()
      --       vim.cmd.Git({ "pull" })
      --     end,
      --     desc = "Git Pull"
      --   },
      --   {
      --     "<leader>gr",
      --     function()
      --       vim.cmd.Git({ "push -u origin HEAD" })
      --     end,
      --     desc = "Git Push (with setting remote tracking)"
      --   },
    },
    dependencies = {
      "https://tpope.io/vim/rhubarb.git",
    }
  },

  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "" },
        topdelete = { text = "▲" },
        changedelete = { text = "▎" },
        untracked = { text = "▎" },
      },

      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map('n', ']h', function()
          if vim.wo.diff then return ']c' end
          vim.schedule(function() gs.next_hunk() end)
          return '<Ignore>'
        end, { expr = true, desc = "next hunk" })

        map('n', '[h', function()
          if vim.wo.diff then return '[c' end
          vim.schedule(function() gs.prev_hunk() end)
          return '<Ignore>'
        end, { expr = true, desc = "previous hunk" })

        -- Actions
        map('n', '<leader>hs', gs.stage_hunk, { desc = "Stage hunk (Git)" })
        map('n', '<leader>hr', gs.reset_hunk, { desc = "Reset hunk (Git)" })
        map('v', '<leader>hs', function() gs.stage_hunk { vim.fn.line('.'), vim.fn.line('v') } end,
          { desc = "Stage selected lines (Git)" })
        map('v', '<leader>hr', function() gs.reset_hunk { vim.fn.line('.'), vim.fn.line('v') } end,
          { desc = "Reset selected lines (Git)" })
        map('n', '<leader>hS', gs.stage_buffer, { desc = "Stage buffer (Git)" })
        map('n', '<leader>hu', gs.undo_stage_hunk, { desc = "Undo stage hunk (Git)" })
        map('n', '<leader>hR', gs.reset_buffer, { desc = "Reset buffer (Git)" })
        map('n', '<leader>hp', gs.preview_hunk, { desc = "preview hunk (Git)" })
        map('n', '<leader>hb', function() gs.blame_line { full = true } end, { desc = "Blame window (Git)" })
        map('n', '<leader>hT', gs.toggle_current_line_blame, { desc = "Toggle current line blame (Git)" })
        map('n', '<leader>hd', gs.diffthis, { desc = "Diff this file (Git)" })
        map('n', '<leader>hD', function() gs.diffthis('~') end, { desc = "Diff to previous (Git)" })
        map('n', '<leader>ht', gs.toggle_deleted, { desc = "Toggle deleted (Git)" })

        -- Text object
        map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', { desc = "Hunk (Git)" })
      end
    },
    config = true
  },

  {
    'pwntester/octo.nvim',
    cmd = {
      "Octo",
      "O",
    },
    config = true,
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope.nvim',
      'nvim-tree/nvim-web-devicons',
    },
  }

}
