{
  description = "Portable Niri and Noctalia desktop for NixOS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    catppuccin = {
      url = "github:catppuccin/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Keep Noctalia's own nixpkgs for its newer build dependencies.
    noctalia.url = "github:noctalia-dev/noctalia";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      catppuccin,
      noctalia,
      ...
    }:
    {
      nixosModules.default = import ./modules {
        inherit home-manager catppuccin;
        homeModule = self.homeModules.default;
      };

      nixosModules.nvidia-offload = import ./modules/nixos/nvidia-offload.nix;

      homeModules.default =
        { pkgs, ... }:
        let
          unstablePkgs = import noctalia.inputs.nixpkgs {
            inherit (pkgs.stdenv.hostPlatform) system;
            config.allowUnfree = true;
          };
        in
        {
          imports = [
            noctalia.homeModules.default
            catppuccin.homeModules.default
            ./home
          ];

          # Stable 26.05 lacks ChatGPT for Linux and T3 Code uses EOL Electron 40.
          # Reuse Noctalia's locked unstable input for both desktop applications.
          home.packages = with unstablePkgs; [
            chatgpt
            t3code
          ];
        };

      checks =
        nixpkgs.lib.genAttrs
          [
            "x86_64-linux"
            "aarch64-linux"
          ]
          (system: {
            niri-config = import ./home/niri-config.nix {
              pkgs = nixpkgs.legacyPackages.${system};
            };
          });

      formatter = nixpkgs.lib.genAttrs [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ] (system: nixpkgs.legacyPackages.${system}.nixfmt-tree);
    };
}
