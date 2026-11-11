{
  lib,
  pkgs,
  osConfig ? { },
  ...
}:

let
  osu = pkgs.osu-lazer-bin;
  offload = osConfig.hardware.nvidia.prime.offload.enableOffloadCmd or false;
  osuWithOffload = pkgs.symlinkJoin {
    name = "osu-lazer-nvidia-offload";
    paths = [
      (pkgs.writeShellScriptBin "osu!" ''
        exec /run/current-system/sw/bin/nvidia-offload ${lib.getExe osu} "$@"
      '')
      osu
    ];
  };
in
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
      package-version-server
      code-cursor
      go
      git
      ripgrep
      fd
    ])
    ++ lib.optionals (pkgs.stdenv.hostPlatform.system == "x86_64-linux") [
      # These upstream binaries are unavailable on aarch64-linux.
      pkgs.discord
      pkgs.spotify
      # Official binary supports score submission and multiplayer.
      (if offload then osuWithOffload else osu)
    ];

  home.sessionVariables.TERMINAL = "ghostty";

  xdg.desktopEntries = {
    github = {
      name = "GitHub";
      comment = "Open github.com";
      exec = "${lib.getExe' pkgs.xdg-utils "xdg-open"} https://github.com";
      icon = "internet-web-browser";
      terminal = false;
      categories = [ "Network" ];
      settings.Keywords = "github.com;code;repositories;pull requests;";
    };
    linear = {
      name = "Linear";
      comment = "Open linear.app";
      exec = "${lib.getExe' pkgs.xdg-utils "xdg-open"} https://linear.app";
      icon = "internet-web-browser";
      terminal = false;
      categories = [ "Network" ];
      settings.Keywords = "linear.app;issues;projects;tasks;";
    };
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications."inode/directory" = [ "thunar.desktop" ];
  };
}
