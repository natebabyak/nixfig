{
  # Opt-in Intel + NVIDIA PRIME offload support. Set PCI bus IDs in the host.
  services.xserver.videoDrivers = [
    "modesetting"
    "nvidia"
  ];
  hardware.graphics.enable = true;

  hardware.nvidia = {
    modesetting.enable = true;
    open = true;

    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
    };
  };
}
