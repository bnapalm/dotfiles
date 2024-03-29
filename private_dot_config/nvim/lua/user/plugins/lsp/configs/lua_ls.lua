require('lazy').load({ plugins = { 'neodev.nvim' } })
return {
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT'
      },

      diagnostics = {
        globals = { "vim" },
      },

      workspace = {
        library = {
          [vim.fn.expand("$VIMRUNTIME/lua")] = true,
          [vim.fn.stdpath("config") .. "/lua"] = true,
        },
        checkThirdParty = false,
      },

      telemetry = {
        enable = false,
      },

      completion = {
        callSnippet = "Replace"
      },
    },
  },
}
