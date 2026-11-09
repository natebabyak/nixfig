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

  programs.thunar.enable = true;
  services.gvfs.enable = true;

  programs.appimage = {
    enable = true;
    binfmt = true;
  };

  hardware.graphics.enable = true;

  environment.systemPackages = [ pkgs.xwayland-satellite ];

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    noto-fonts
    noto-fonts-color-emoji
  ];
}
