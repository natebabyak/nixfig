{
  config,
  lib,
  pkgs,
  ...
}:

{
  # A small text login screen. Start niri-session so systemd services and
  # desktop portals share the correct Wayland session environment.
  services.greetd = {
    enable = lib.mkDefault true;
    useTextGreeter = true;
    settings.default_session = {
      command = "${lib.getExe pkgs.tuigreet} --time --cmd ${config.programs.niri.package}/bin/niri-session";
    };
  };
}
