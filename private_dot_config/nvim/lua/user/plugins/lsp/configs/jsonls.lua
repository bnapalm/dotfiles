-- vscode-json-language-server (mason package: json-lsp)
-- provides formatting (<leader>lf) and syntax/schema diagnostics
return {
  settings = {
    json = {
      validate = { enable = true },
      format = { enable = true },
      -- schemas are picked up from $schema in the file; add more here if needed
      -- schemas = { { fileMatch = { "package.json" }, url = "https://json.schemastore.org/package.json" } },
    },
  },
  init_options = {
    provideFormatter = true,
  },
}
