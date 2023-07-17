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
  "gopls",
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
    lspconfig.yamlls.setup(require("user.lsp.settings.yamlls"))
  end,
  ['gopls'] = function ()
    lspconfig.gopls.setup(require("user.lsp.settings.gopls"))
  end
})

--[[ local status_ok_2, mason_null_ls = pcall(require, "mason-null-ls") ]]
--[[ if not status_ok_2 then ]]
--[[   return ]]
--[[ end ]]
--[[]]
--[[ mason_null_ls.setup({ ]]
--[[   ensure_installed = { ]]
--[[     "prettier", ]]
--[[     "prettierd" ]]
--[[   }, ]]
--[[   automatic_installation = true ]]
--[[ }) ]]
