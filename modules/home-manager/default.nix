{ catppuccin, noctalia }:

{ lib, pkgs, ... }:

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
    ./apps.nix
    ./niri.nix
    ./noctalia.nix
    ./theme.nix
  ];

  assertions = [
    {
      assertion = lib.versionAtLeast unstablePkgs.bun.version "1.4.4";
      message = "nixfig requires Bun 1.4.4 or newer.";
    }
  ];

  # Stable 26.05 has an older Bun, lacks ChatGPT for Linux, and T3 Code uses EOL Electron 40.
  # Reuse Noctalia's locked unstable input for these packages.
  home.packages = with unstablePkgs; [
    bun
    chatgpt
    t3code
  ];

  home.stateVersion = lib.mkDefault "26.05";

  programs.home-manager.enable = true;

  xdg.enable = true;
  xdg.userDirs = {
    enable = true;
    createDirectories = true;
  };
}
