local status_ok, mason = pcall(require, "mason")
if not status_ok then
	return
end

local status_ok_1, mason_lspconfig = pcall(require, "mason-lspconfig")
if not status_ok_1 then
	return
end

local servers = {
  "jsonls",
  "lua_ls",
  "tflint",
  "terraformls",
  "pyright",
  "yamlls",
  "bashls",
  "beancount",
  "gopls"
}

local settings = {
  ui = {
    border = "rounded",
    --[[ icons = { ]]
    --[[   package_installed = "◍", ]]
    --[[   package_pending = "◍", ]]
    --[[   package_uninstalled = "◍", ]]
    --[[ }, ]]
  },
  log_level = vim.log.levels.INFO,
  max_concurrent_installers = 4,
}

mason.setup(settings)
mason_lspconfig.setup {
  ensure_installed = servers,
  automatic_installation = true,
}

local lspconfig_status_ok, lspconfig = pcall(require, "lspconfig")
if not lspconfig_status_ok then
  return
end

local cmp_lsp_ok, cmp_nvm_lsp = pcall(require, "cmp_nvim_lsp")
if not cmp_lsp_ok then
  return
end

local lsp_defaults = lspconfig.util.default_config

lsp_defaults.capabilities = vim.tbl_deep_extend(
  'force',
  lsp_defaults.capabilities,
  cmp_nvm_lsp.default_capabilities()
)

mason_lspconfig.setup_handlers({
  function (server)
    lspconfig[server].setup({})
  end,
  ['beancount'] = function ()
    lspconfig.beancount.setup(require("user.lsp.settings.beancount"))
  end,
  ['lua_ls'] = function ()
    lspconfig.lua_ls.setup(require("user.lsp.settings.lua_ls"))
  end,
  ['yamlls'] = function ()
    lspconfig.lua_ls.setup(require("user.lsp.settings.yamlls"))
  end,
  ['gopls'] = function ()
    lspconfig.gopls.setup(require("user.lsp.settings.gopls"))
  end
})

--[[ local opts = {} ]]

--[[ for _, server in pairs(servers) do ]]
--[[   opts = { ]]
--[[     on_attach = require("user.lsp.handlers").on_attach, ]]
--[[     capabilities = require("user.lsp.handlers").capabilities, ]]
--[[   } ]]
--[[]]
--[[   server = vim.split(server, "@")[1] ]]
--[[]]
--[[   if server.name == "beancount" then ]]
--[[     local beancount_opts = require("user.lsp.settings.beancount") ]]
--[[     opts = vim.tbl_deep_extend("force", beancount_opts, opts) ]]
--[[   end ]]
--[[]]
--[[   -- if server == "jsonls" then ]]
--[[     -- local jsonls_opts = require "user.lsp.settings.jsonls" ]]
--[[     -- opts = vim.tbl_deep_extend("force", jsonls_opts, opts) ]]
--[[   -- end ]]
--[[]]
--[[ 	if server.name == "sumneko_lua" then ]]
--[[ 	 	local sumneko_opts = require("user.lsp.settings.sumneko_lua") ]]
--[[ 	 	opts = vim.tbl_deep_extend("force", sumneko_opts, opts) ]]
--[[ 	end ]]
--[[]]
--[[   if server.name == "yamlls" then ]]
--[[]]
--[[ 	 	local yamlls_opts = require("user.lsp.settings.yamlls") ]]
--[[ 	 	opts = vim.tbl_deep_extend("force", yamlls_opts, opts) ]]
--[[]]
--[[     -- Disable diagnostics for helm files ]]
--[[     local default_on_attach = opts.on_attach ]]
--[[     opts.on_attach = function (client, bufnr) ]]
--[[       default_on_attach(client, bufnr) ]]
--[[       if vim.bo[bufnr].buftype ~= "" or vim.bo[bufnr].filetype == "helm" then ]]
--[[         vim.diagnostic.disable() ]]
--[[       end ]]
--[[     end ]]
--[[]]
--[[   end ]]
--[[]]
--[[   -- if server == "pyright" then ]]
--[[     -- local pyright_opts = require "user.lsp.settings.pyright" ]]
--[[     -- opts = vim.tbl_deep_extend("force", pyright_opts, opts) ]]
--[[   -- end ]]
--[[]]
--[[   lspconfig[server].setup(opts) ]]
--[[   ::continue:: ]]
--[[ end ]]
