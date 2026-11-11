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
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        modules = [
          self.nixosModules.default
          ./hosts/nixos
        ];
      };

      nixosModules.default = import ./modules {
        inherit home-manager catppuccin;
        homeModule = self.homeModules.default;
      };

      nixosModules.nvidia-offload = import ./modules/nixos/nvidia-offload.nix;

      homeModules.default = import ./modules/home-manager {
        inherit catppuccin noctalia;
      };

      checks =
        nixpkgs.lib.genAttrs
          [
            "x86_64-linux"
            "aarch64-linux"
          ]
          (
            system:
            let
              hosts = nixpkgs.lib.filterAttrs (
                _: host: host.config.nixpkgs.hostPlatform.system == system
              ) self.nixosConfigurations;
            in
            {
              niri-config = import ./modules/home-manager/niri-config.nix {
                pkgs = nixpkgs.legacyPackages.${system};
              };
            }
            // nixpkgs.lib.mapAttrs' (
              name: host:
              nixpkgs.lib.nameValuePair "niri-${name}"
                host.config.home-manager.users.${host.config.nixfig.username}.xdg.configFile."niri/config.kdl".source
            ) hosts
          );

      formatter = nixpkgs.lib.genAttrs [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ] (system: nixpkgs.legacyPackages.${system}.nixfmt-tree);
    };
}
