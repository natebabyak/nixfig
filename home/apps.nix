{ lib, pkgs, ... }:

{
  programs.bash.enable = true;
  programs.gh.enable = true;
  programs.firefox = {
    enable = true;
    policies.ExtensionSettings."uBlock0@raymondhill.net" = {
      install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
      installation_mode = "normal_installed";
    };
  };
  programs.thunderbird.enable = true;
  programs.ghostty = {
    enable = true;
    settings = {
      font-family = "JetBrainsMono Nerd Font";
      font-size = 12;
      window-decoration = false;
    };
  };

  home.packages =
    (with pkgs; [
      zed-editor
      code-cursor
      discord
      spotify
      go
      bun
      git
      ripgrep
      fd
    ])
    ++ lib.optionals (pkgs.stdenv.hostPlatform.system == "x86_64-linux") [
      # Official binary supports score submission and multiplayer.
      pkgs.osu-lazer-bin
    ];

  home.sessionVariables.TERMINAL = "ghostty";

  xdg.mimeApps = {
    enable = true;
    defaultApplications."inode/directory" = [ "thunar.desktop" ];
  };
}
