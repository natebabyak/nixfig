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

  # Pin the official desktop release independently of nixpkgs.
  t3code =
    let
      version = "0.1.11";
      source = {
        x86_64-linux = {
          arch = "x86_64";
          hash = "sha256-i6oGp7uqP3KdaUZvshHtcAbWpuTYALns2s2DH9FoaxQ=";
        };
        aarch64-linux = {
          arch = "arm64";
          hash = "sha256-Pa+IzPF1SLwp/4pueOIl3vBpa0RJjF9QBXBI4YLxRiY=";
        };
      }.${pkgs.stdenv.hostPlatform.system};
      src = pkgs.fetchurl {
        url = "https://github.com/pingdotgg/t3code/releases/download/v${version}/T3-Code-${source.arch}.AppImage";
        inherit (source) hash;
      };
      contents = pkgs.appimageTools.extractType2 {
        pname = "t3code";
        inherit version src;
      };
    in
    pkgs.appimageTools.wrapType2 {
      pname = "t3code-desktop";
      inherit version src;
      extraInstallCommands = ''
        install -Dm444 ${contents}/t3code.desktop "$out/share/applications/t3code.desktop"
        substituteInPlace "$out/share/applications/t3code.desktop" \
          --replace-fail 'Exec=AppRun' "Exec=$out/bin/t3code-desktop"
        cp -r ${contents}/usr/share/icons "$out/share/icons"
      '';
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
      t3code
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
