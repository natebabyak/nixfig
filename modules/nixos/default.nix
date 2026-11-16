{ pkgs, ... }:

{
  imports = [
    ./desktop.nix
    ./greeter.nix
    ./services.nix
  ];

  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      stdenv.cc.cc
      zlib
      openssl
      curl
      sqlite
    ];
  };

  # Prefer native user installations, including Claude Code.
  environment.localBinInPath = true;
}
