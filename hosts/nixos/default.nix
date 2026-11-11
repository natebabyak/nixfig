{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos/nvidia-offload.nix
  ];

  networking.hostName = "nixos";
  nixfig.username = "nateb";
  users.users.nateb.description = "Nate Babyak";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  time.timeZone = "America/Toronto";
  i18n.defaultLocale = "en_CA.UTF-8";
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  hardware.nvidia.prime = {
    intelBusId = "PCI:0@0:2:0";
    nvidiaBusId = "PCI:1@0:0:0";
  };

  home-manager.users.nateb = {
    home.stateVersion = "26.05";
    nixfig.niri = {
      extraConfig = builtins.readFile ./niri.kdl;
      # Keep desktop rendering on NVIDIA for the external display.
      renderDrmDevice = "/dev/dri/by-path/pci-0000:01:00.0-render";
    };
  };

  # Compatibility versions belong to each host and must not track input updates.
  system.stateVersion = "26.05";
}
