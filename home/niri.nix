{ osConfig, pkgs, ... }:

{
  xdg.configFile."niri/config.kdl".source = pkgs.runCommand "niri-config.kdl" { } ''
    ${osConfig.programs.niri.package}/bin/niri validate --config ${./niri.kdl}
    cp ${./niri.kdl} "$out"
  '';
}
