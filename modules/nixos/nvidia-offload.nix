{ lib, ... }:

{
  # Hardware module for the Intel + RTX 3070 laptop.
  services.xserver.videoDrivers = [ "modesetting" "nvidia" ];
  hardware.graphics.enable = true;

  hardware.nvidia = {
    modesetting.enable = true;
    open = true;

    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };

      # Defaults for this laptop; other hosts can override their PCI addresses.
      intelBusId = lib.mkDefault "PCI:0@0:2:0";
      nvidiaBusId = lib.mkDefault "PCI:1@0:0:0";
    };
  };
}
