{
  home-manager,
  homeModule,
  catppuccin,
}:

{ config, lib, ... }:

let
  username = config.nixfig.username;
  theme = import ../theme.nix;
in
{
  imports = [
    home-manager.nixosModules.home-manager
    catppuccin.nixosModules.default
    ./nixos
  ];

  options.nixfig.username = lib.mkOption {
    type = lib.types.str;
    default = "nateb";
    description = "Account receiving the shared desktop and applications.";
  };

  config = {
    nixpkgs.config.allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) [
        "discord"
        "spotify"
        "cursor"
      ];

    catppuccin = {
      enable = true;
      autoEnable = true;
      inherit (theme) flavor accent;
      tty.enable = false;
    };

    # Avoid building theme assets during configuration evaluation.
    console.colors = map (name: lib.removePrefix "#" theme.colors.${name}) [
      "base"
      "red"
      "green"
      "yellow"
      "blue"
      "pink"
      "teal"
      "subtext1"
      "surface2"
      "red"
      "green"
      "yellow"
      "blue"
      "pink"
      "teal"
      "subtext0"
    ];

    users.users.${username} = {
      isNormalUser = lib.mkDefault true;
      extraGroups = [
        "wheel"
        "networkmanager"
        "docker"
      ];
    };

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      users.${username} = homeModule;
    };
  };
}
