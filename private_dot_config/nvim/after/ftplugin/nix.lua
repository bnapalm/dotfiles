local nix = require("user.nix")

vim.api.nvim_buf_create_user_command(0, "NixExplodeAttrpathOnce", function()
  nix.explode_attrpath_once()
end, { desc = "Explode Nix attrpath at the nearest dot" })

vim.api.nvim_buf_create_user_command(0, "NixExplodeAttrpathAll", function()
  nix.explode_attrpath_all()
end, { desc = "Explode a Nix attrpath into nested attrsets" })

vim.keymap.set("n", "<leader>ne", nix.explode_attrpath_once, {
  buffer = true,
  desc = "Explode Nix attrpath once",
})

vim.keymap.set("n", "<leader>nE", nix.explode_attrpath_all, {
  buffer = true,
  desc = "Explode Nix attrpath fully",
})
