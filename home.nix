{ pkgs, ... }:

{
  home.username = "YOUR_USERNAME";
  home.homeDirectory = "/home/YOUR_USERNAME";

  home.stateVersion = "26.05";

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    bun
    go
    nodejs
    ripgrep
    fd
    btop
  ];

  xdg.configFile."niri/config.kdl".source =
    ./niri.kdl;
}
