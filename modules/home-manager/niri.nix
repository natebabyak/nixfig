{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.nixfig.niri = {
    extraConfig = lib.mkOption {
      type = lib.types.lines;
      default = "";
      description = "Host-specific Niri settings, such as monitor modes and positions.";
    };
    renderDrmDevice = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "Optional DRM render device; null lets Niri select the GPU.";
    };
  };

  config.xdg.configFile."niri/config.kdl".source = import ./niri-config.nix {
    inherit pkgs;
    inherit (config.nixfig.niri) extraConfig renderDrmDevice;
  };
}
