return {

  {
    "tpope/vim-fugitive",
    cmd = {
      "Git",
      "G",
      "Gbrowse"
    },
    keys = {
      { "<leader>gs", vim.cmd.Git, desc = "Fugitive Status" },
      {
        "<leader>gp",
        function()
          vim.cmd.Git({ "push" })
        end,
        desc = "Git Push"
      },
      {
        "<leader>gl",
        function()
          vim.cmd.Git({ "pull" })
        end,
        desc = "Git Pull"
      },
      {
        "<leader>gr",
        function()
          vim.cmd.Git({ "push -u origin HEAD" })
        end,
        desc = "Git Push (with setting remote tracking)"
      },
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
    'ThePrimeagen/git-worktree.nvim',
    keys = {
      {
        '<leader>sr',
        function()
          require('telescope').extensions.git_worktree.git_worktrees()
        end,
        desc = "Git Worktree"
      },
      {
        '<leader>sR',
        function()
          require('telescope').extensions.git_worktree.create_git_worktree()
        end,
        desc = "Git Worktree Create"
      },
    },
    config = function(_, opts)
      local worktree = require("git-worktree")
      local workspaces = require("workspaces")
      local ws_path = require("workspaces.util").path
      require("telescope").load_extension("git_worktree")
      worktree.setup(opts)

      worktree.on_tree_change(function(op, metadata)
        if op == worktree.Operations.Switch then
          local norm_prev_path = ws_path.normalize(metadata.prev_path)
          local ws_name = vim.tbl_filter(function(ws_sel)
            return ws_sel.path == norm_prev_path
          end, workspaces.get())[1].name or nil
          if ws_name == nil then return end
          workspaces.remove(ws_name)
          workspaces.add(ws_name, metadata.path)
          print("switch from " .. norm_prev_path .. " to " .. metadata.path)
          print(vim.inspect(ws_name))
        end
      end)
    end,
    dependencies = {
      'nvim-telescope/telescope.nvim'
    }
  },

}
