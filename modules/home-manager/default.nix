{
  inputs,
  catppuccin,
  noctalia,
  claude-desktop,
}:

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

  # Reuse Noctalia's locked unstable input for newer application dependencies.
  home.packages =
    (with unstablePkgs; [
      bun
      chatgpt
      antigravity-cli
    ])
    ++ [
      inputs.nixpkgs-unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system}.t3code
      # Avoid the FHS wrapper's restrictions on Claude Code's spawned shells.
      claude-desktop.packages.${pkgs.stdenv.hostPlatform.system}.claude-desktop
    ];

  home.stateVersion = lib.mkDefault "26.05";

  programs.home-manager.enable = true;

  xdg.enable = true;
  xdg.userDirs = {
    enable = true;
    createDirectories = true;
  };
}
