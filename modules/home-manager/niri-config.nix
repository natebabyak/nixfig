{
  pkgs,
  extraConfig ? "",
  renderDrmDevice ? null,
}:

let
  theme = import ../../theme.nix;
  configFile = pkgs.replaceVars ./niri.kdl {
    inherit (theme.colors)
      base
      mantle
      surface1
      red
      ;
    accent = theme.colors.${theme.accent};
    inherit extraConfig;
    renderDrmDevice =
      if renderDrmDevice == null then "" else "render-drm-device ${builtins.toJSON renderDrmDevice}";
  };
in
pkgs.runCommand "niri-config.kdl" { } ''
  ${pkgs.niri}/bin/niri validate --config ${configFile}
  cp ${configFile} "$out"
''
