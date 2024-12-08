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
    dependencies = 'rafamadriz/friendly-snippets',

    -- use a release tag to download pre-built binaries
    version = 'v0.7.3',
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
        ['<S-CR>'] = { 'accept' },
      },

      appearance = {
        -- Sets the fallback highlight groups to nvim-cmp's highlight groups
        -- Useful for when your theme doesn't support blink.cmp
        -- will be removed in a future release
        use_nvim_cmp_as_default = true,
        -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- Adjusts spacing to ensure icons are aligned
        nerd_font_variant = 'mono'
      },

      -- default list of enabled providers defined so that you can extend it
      -- elsewhere in your config, without redefining it, via `opts_extend`
      sources = {
        completion = {
          enabled_providers = { 'lsp', 'path', 'snippets', 'buffer', 'lazydev' },
        },
        providers = {
          -- dont show LuaLS require statements when lazydev has items
          lsp = { fallback_for = { "lazydev" } },
          lazydev = { name = "LazyDev", module = "lazydev.integrations.blink" },
        },
      },

      -- experimental auto-brackets support
      completion = {
        accept = { auto_brackets = { enabled = true } },
        documentation = { auto_show = true },
      },

      -- experimental signature help support
      signature = { enabled = true }
    },
    -- allows extending the enabled_providers array elsewhere in your config
    -- without having to redefine it
    opts_extend = { "sources.completion.enabled_providers" }
  },

  {
    "hrsh7th/nvim-cmp",
    enabled = false,
    opts = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      return {

        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end
        },

        mapping = {
          ['<C-t>'] = cmp.mapping.scroll_docs(-4),
          ['<C-d>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          -- ['<C-l>'] = cmp.mapping.abort(),
          ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<CR>"] = cmp.mapping.confirm({ select = false }),
          ["<S-CR>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          }),

          ["<Esc>"] = cmp.mapping(function(fallback)
            if cmp.visible() and luasnip.expand_or_locally_jumpable() then
              cmp.abort()
            else
              fallback()
            end
          end, { "i", "s" }),
        },

        sources = cmp.config.sources({
          { name = "lazydev", group_index = 0 },
          { name = "nvim_lua" },
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer",  keyword_length = 4 },
          { name = "path" },
        }),

        formatting = {
          fields = { "kind", "abbr", "menu" },
          format = require('lspkind').cmp_format({
            mode = "symbol",
            menu = ({
              nvim_lsp = "[LSP]",
              nvim_lua = "[NVIM]",
              luasnip = "[Snip]",
              buffer = "[Buff]",
              path = "[Path]",
            }),
            symbol_map = {
              Snippet = "",
            }
          }),
        },

        window = {
          documentation = {
            border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
          }
        },

        experimental = {
          ghost_text = false,
          native_menu = false,
        },

        completion = {
          get_trigger_characters = function(trigger_characters)
            return vim.tbl_filter(function(char)
              return char ~= ' '
            end, trigger_characters)
          end
        }
      }
    end,

    dependencies = {
      "hrsh7th/cmp-nvim-lua",
      "hrsh7th/cmp-nvim-lsp",
      {
        "saadparwaiz1/cmp_luasnip",
        dependencies = {
          "L3MON4D3/LuaSnip"
        }
      },
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
      'onsails/lspkind.nvim',
    },
  }
}
