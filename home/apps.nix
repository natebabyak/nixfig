{ pkgs, ... }:

{
  programs.bash.enable = true;
  programs.firefox.enable = true;
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
    go
    bun
    git
    ripgrep
    fd
  ];

  home.sessionVariables.TERMINAL = "ghostty";
}
