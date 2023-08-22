return {
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

        -- filter workspace where path == source path
        local ws_tbl = vim.tbl_filter(function(ws_sel)
          return ws_sel.path == norm_prev_path
        end, workspaces.get())

        -- should only be 1 workspace
        -- do nothing if no workspace found
        if vim.tbl_isempty(ws_tbl) then return end
        local ws_name = ws_tbl[1].name or nil

        -- should not happen
        if ws_name == nil then return end

        local new_path = metadata.path

        -- if new_path is not a full directory path, attach worktree root
        if not string.find(new_path, ws_path.sep) then
          new_path = worktree.get_root() .. ws_path.sep .. new_path
        end

        -- workspaces.remove(ws_name)
        -- workspaces.add(ws_name, new_path)
        workspaces.set_path(ws_name, new_path)
        -- print("switched git-worktree workspace from " .. norm_prev_path .. " to " .. new_path)
      end
    end)
  end,

  dependencies = {
    'nvim-telescope/telescope.nvim',
    "0x0013/workspaces.nvim",
    -- "natecraddock/workspaces.nvim",
  }
}
