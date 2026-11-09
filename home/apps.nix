{ pkgs, ... }:

{
  programs.bash.enable = true;
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

  home.packages = with pkgs; [
    zed-editor
    discord
    spotify
    go
    bun
    git
    ripgrep
    fd
  ];

  home.sessionVariables.TERMINAL = "ghostty";
}
