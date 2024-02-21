local has_words_before = function()
  unpack = unpack or table.unpack
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

return {
  {
    "L3MON4D3/LuaSnip",
    version = "v2.*",
    keys = {
      { "<C-h>", function() require("luasnip").jump(1) end,  mode = { "i", "s" } },
      { "<C-l>", function() require("luasnip").jump(-1) end, mode = { "i", "s" } },
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
      require("luasnip.loaders.from_vscode").lazy_load()
    end,
    dependencies = {
      "rafamadriz/friendly-snippets"
    }
  },
  {
    "hrsh7th/nvim-cmp",
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

          -- ["<Tab>"] = cmp.mapping(function(fallback)
          --   if cmp.visible() then
          --     cmp.select_next_item()
          --   elseif luasnip.expand_or_locally_jumpable() then
          --     luasnip.expand_or_jump()
          --   elseif has_words_before() then
          --     -- cmp.complete()
          --     fallback()
          --   else
          --     fallback()
          --   end
          -- end, { "i", "s" }),
          --
          -- ["<S-Tab>"] = cmp.mapping(function(fallback)
          --   if cmp.visible() then
          --     cmp.select_prev_item()
          --   elseif luasnip.jumpable(-1) then
          --     luasnip.jump(-1)
          --   else
          --     fallback()
          --   end
          -- end, { "i", "s" }),
        },

        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "nvim_lua" },
          { name = "luasnip" },
          { name = "buffer", keyword_length = 4 },
          { name = "path" },
        }),

        formatting = {
          fields = { "kind", "abbr", "menu" },
          format = require('lspkind').cmp_format({
            mode = "symbol",
            menu = ({
              nvim_lsp = "[LSP]",
              nvim_lua = "[NVIM_LUA]",
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
