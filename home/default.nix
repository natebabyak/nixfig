{ lib, ... }:

{
  imports = [
    ./apps.nix
    ./niri.nix
    ./noctalia.nix
    ./theme.nix
  ];

  home.stateVersion = lib.mkDefault "26.05";

  programs.home-manager.enable = true;

  xdg.enable = true;
  xdg.userDirs = {
    enable = true;
    createDirectories = true;
  };
}
