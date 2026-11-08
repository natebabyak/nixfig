{ pkgs, ... }:

{
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  programs.niri = {
    enable = true;
    useNautilus = false;
  };
  hardware.graphics.enable = true;

  environment.systemPackages = [ pkgs.xwayland-satellite ];

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    noto-fonts
    noto-fonts-color-emoji
  ];
}
