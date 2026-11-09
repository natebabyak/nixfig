{ config, lib, ... }:

{
  networking.networkmanager.enable = lib.mkDefault true;
  hardware.bluetooth.enable = lib.mkDefault true;

  virtualisation.docker.enable = true;

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };
  services.pulseaudio.enable = false;

  services.upower.enable = lib.mkDefault true;
  services.power-profiles-daemon.enable = lib.mkIf (!config.services.tuned.enable) (
    lib.mkDefault true
  );
}
