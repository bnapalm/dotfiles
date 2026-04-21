---@diagnostic disable missing-fields
---@type LazySpec
return {
  {
    "L3MON4D3/LuaSnip",
    version = "v2.*",
    keys = {
      {
        "<C-t>",
        function()
          local ls = require("luasnip")
          if ls.expand_or_jumpable() then
            ls.expand_or_jump()
          end
        end,
        mode = { "i", "s" }
      },
      {
        "<C-m>",
        function()
          local ls = require("luasnip")
          if ls.jumpable(-1) then
            ls.jump(-1)
          end
        end,
        mode = { "i", "s" }
      },
      {
        "<C-s>",
        function()
          local ls = require("luasnip")
          if ls.choice_active() then
            ls.change_choice(1)
          end
        end,
        mode = { "i", "s" }
      },
    },
    build = "make install_jsregexp",
    config = function()
      require("luasnip.loaders.from_lua").lazy_load({ paths = { vim.fn.stdpath("config") .. "/lua/user/snip" } })
      require("luasnip.loaders.from_vscode").lazy_load({
        paths = { vim.fn.stdpath("config") .. "/snippets" },
        exclude = {
          "plaintext",
          "markdown",
          "tex",
          "html",
          "global",
          "all",
          "go",
        },
      })
    end,
    dependencies = {
      "rafamadriz/friendly-snippets"
    }
  },

  {
    'saghen/blink.cmp',
    lazy = false, -- lazy loading handled internally
    -- optional: provides snippets for the snippet source
    dependencies = {
      'rafamadriz/friendly-snippets',
      { 'yus-works/csc.nvim', opts = {} },
    },

    -- use a release tag to download pre-built binaries
    version = '1.*',
    -- OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
    -- build = 'cargo build --release',
    -- If you use nix, you can build from source using latest nightly rust with:
    -- build = 'nix run .#build-plugin',

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      -- 'default' for mappings similar to built-in completion
      -- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
      -- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
      -- see the "default configuration" section below for full documentation on how to define
      -- your own keymap.
      keymap = {
        preset = 'default',
        ['<S-CR>'] = { 'accept', 'fallback' },
      },

      appearance = {
        -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- Adjusts spacing to ensure icons are aligned
        nerd_font_variant = 'mono'
      },

      -- default list of enabled providers defined so that you can extend it
      -- elsewhere in your config, without redefining it, via `opts_extend`
      sources = {
        default = function()
          -- Commit messages only need snippet templates, repo-history scopes and
          -- nearby buffer words; LSP/LazyDev are noise in this context.
          if vim.bo.filetype == 'gitcommit' then
            return { 'snippets', 'buffer', 'path' }
          end

          return { 'lsp', 'path', 'snippets', 'buffer', 'lazydev' }
        end,
        per_filetype = {
          ['pi-chat-prompt'] = { 'pi' },
        },
        providers = {
          pi = {
            name = 'Pi',
            module = 'pi.completion.blink',
          },
          lsp = {
            -- HACK: Work around gopls returning a zero-width completion edit in syntactically
            -- invalid Go buffers (e.g. `foo === fa|`), which causes blink to insert `false`
            -- at the cursor instead of replacing the typed prefix. When gopls gives us an
            -- edit at the cursor for a Go identifier, rewrite it to replace the current
            -- identifier prefix. Related upstream issues: golang/go#32510, golang/go#72753.
            transform_items = function(ctx, items)
              if vim.bo[ctx.bufnr].filetype ~= "go" then
                return items
              end

              local row = ctx.cursor[1] - 1
              local col = ctx.cursor[2]
              local line = vim.api.nvim_buf_get_lines(ctx.bufnr, row, row + 1, false)[1] or ""

              local start_col = col
              while start_col > 0 and line:sub(start_col, start_col):match("[%w_]") do
                start_col = start_col - 1
              end

              for _, item in ipairs(items) do
                local client = item.client_id and vim.lsp.get_client_by_id(item.client_id) or nil
                if client and client.name == "gopls" and item.textEdit and item.textEdit.newText then
                  local edit = item.textEdit
                  local range = edit.range or edit.insert or edit.replace

                  if range
                    and range.start.line == row
                    and range["end"].line == row
                    and range.start.character == col
                    and range["end"].character == col
                    and start_col < col
                  then
                    item.textEdit = {
                      newText = edit.newText,
                      range = {
                        start = { line = row, character = start_col },
                        ["end"] = { line = row, character = col },
                      },
                    }
                  end
                end
              end

              return items
            end,
          },
          lazydev = {
            name = "LazyDev",
            module = "lazydev.integrations.blink",
            -- dont show LuaLS require statements when lazydev has items
            fallbacks = { "lsp" },
          },
          snippets = {
            transform_items = function(ctx, items)
              if vim.bo[ctx.bufnr].filetype ~= 'gitcommit' then
                return items
              end

              -- These friendly-snippets entries should only win while typing the
              -- first token of the subject line, e.g. `fea|` -> `feat(scope): msg`.
              local conventional = {
                cc = true,
                config = true,
                feat = true,
                fix = true,
                build = true,
                chore = true,
                ci = true,
                docs = true,
                style = true,
                refactor = true,
                perf = true,
                test = true,
              }

              local row = ctx.cursor[1] - 1
              local col = ctx.cursor[2]
              local line = vim.api.nvim_buf_get_lines(ctx.bufnr, row, row + 1, false)[1] or ""
              local before_cursor = line:sub(1, col)
              -- Only treat the cursor as being in the commit type position on the
              -- first line before any `(`, `:`, spaces, or other separators.
              local in_type_position = row == 0 and before_cursor:match('^%l*$') ~= nil

              local filtered = {}
              for _, item in ipairs(items) do
                local label = item.label
                local is_conventional = conventional[label] == true

                if in_type_position and is_conventional then
                  -- Boost commit-type templates when they are actually relevant.
                  item.score_offset = (item.score_offset or 0) + 120
                  table.insert(filtered, item)
                elseif not is_conventional then
                  -- Outside the type position, hide these templates completely so
                  -- they do not pollute scope/body completion.
                  table.insert(filtered, item)
                end
              end

              return filtered
            end,
          },
        },
      },

      -- experimental auto-brackets support
      completion = {
        accept = { auto_brackets = { enabled = true } },
        documentation = {
          auto_show = true,
          window = {
            border = 'rounded'
          }
        },
      },

      -- experimental signature help support
      signature = { enabled = true }
    },
    -- allows extending the enabled_providers array elsewhere in your config
    -- without having to redefine it
    opts_extend = { "sources.completion.enabled_providers" }
  },

}
