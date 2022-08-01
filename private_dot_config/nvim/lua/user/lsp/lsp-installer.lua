local status_ok, lsp_installer = pcall(require, "nvim-lsp-installer")
if not status_ok then
	return
end

-- Register a handler that will be called for all installed servers.
-- Alternatively, you may also register handlers on specific server instances instead (see example below).
lsp_installer.on_server_ready(function(server)
	local opts = {
		on_attach = require("user.lsp.handlers").on_attach,
		capabilities = require("user.lsp.handlers").capabilities,
	}

	 if server.name == "beancount" then
	 	local beancount_opts = require("user.lsp.settings.beancount")
	 	opts = vim.tbl_deep_extend("force", beancount_opts, opts)
	 end

	 if server.name == "jsonls" then
	 	local jsonls_opts = require("user.lsp.settings.jsonls")
	 	opts = vim.tbl_deep_extend("force", jsonls_opts, opts)
	 end

	 if server.name == "gopls" then
	 	local gopls_opts = require("user.lsp.settings.gopls")
	 	opts = vim.tbl_deep_extend("force", gopls_opts, opts)
	 end

	 if server.name == "sumneko_lua" then
	 	local sumneko_opts = require("user.lsp.settings.sumneko_lua")
	 	opts = vim.tbl_deep_extend("force", sumneko_opts, opts)
	 end

  if server.name == "yamlls" then

	 	local yamlls_opts = require("user.lsp.settings.yamlls")
	 	opts = vim.tbl_deep_extend("force", yamlls_opts, opts)

    -- Disable diagnostics for helm files
    local default_on_attach = opts.on_attach
    opts.on_attach = function (client, bufnr)
      default_on_attach(client, bufnr)
      if vim.bo[bufnr].buftype ~= "" or vim.bo[bufnr].filetype == "helm" then
        vim.diagnostic.disable()
      end
    end

  end

	-- This setup() function is exactly the same as lspconfig's setup function.
	-- Refer to https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
	server:setup(opts)
end)

