{ pkgs, ... }:

{
  xdg.configFile."niri/config.kdl".source = import ./niri-config.nix { inherit pkgs; };
}
