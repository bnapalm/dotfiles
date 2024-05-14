return {
  settings = {
    nixd = {
      -- nixpkgs = {
      --   expr = "import (builtins.getFlake \"" .. os.getenv("FLAKE") .. "\").inputs.nixpkgs { }"
      -- },
      formatting = {
        command = { "nixpkgs-fmt" }
      },
      options = {
        nixos = {
          expr = "(builtins.getFlake \"" .. os.getenv("FLAKE") .. "\").nixosConfigurations.melon.options"
        },
        home_manager = {
          expr = "(builtins.getFlake \"" .. os.getenv("FLAKE") .. "\").homeConfigurations.\"black@melon\".options"
        }
      }
    },
  },
}
