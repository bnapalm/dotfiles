return {
  settings = { redhat = { telemetry = { enabled = false }}},
  on_attach = function (client, bufnr)
    default_on_attach(client, bufnr)
    if vim.bo[bufnr].buftype ~= "" or vim.bo[bufnr].filetype == "helm" then
      vim.diagnostic.disable()
    end
  end
}
