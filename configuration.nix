{ pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  programs.niri.enable = true;
  programs.fish.enable = true;

  environment.systemPackages = with pkgs; [
    git
    ghostty
    fuzzel
  ];

  # Keep your installer-generated bootloader,
  # networking, user, and system.stateVersion settings.
}
