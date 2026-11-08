{ pkgs }:

let
  theme = import ../theme.nix;
  configFile = pkgs.replaceVars ./niri.kdl {
    inherit (theme.colors)
      base
      mantle
      surface1
      red
      ;
    accent = theme.colors.${theme.accent};
  };
in
pkgs.runCommand "niri-config.kdl" { } ''
  ${pkgs.niri}/bin/niri validate --config ${configFile}
  cp ${configFile} "$out"
''
