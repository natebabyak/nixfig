{
  programs.noctalia = {
    enable = true;
    settings = {
      theme = {
        mode = "dark";
        source = "builtin";
        builtin = "Catppuccin";
      };
      shell = {
        font_family = "JetBrainsMono Nerd Font";
        polkit_agent = true;
      };
    };
  };
}
