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
    code-cursor
    discord
    spotify
    go
    bun
    git
    ripgrep
    fd
  ];

  home.sessionVariables.TERMINAL = "ghostty";

  xdg.desktopEntries = {
    chatgpt = {
      name = "ChatGPT";
      comment = "Open ChatGPT in Firefox";
      exec = "${pkgs.firefox}/bin/firefox https://chatgpt.com";
      icon = "web-browser";
      terminal = false;
      categories = [ "Network" ];
    };
    linear = {
      name = "Linear";
      comment = "Open Linear in Firefox";
      exec = "${pkgs.firefox}/bin/firefox https://linear.app";
      icon = "web-browser";
      terminal = false;
      categories = [ "Office" ];
    };
  };
}
