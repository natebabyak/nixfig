{
  programs.noctalia = {
    enable = true;
    settings = {
      shell = {
        font_family = "JetBrainsMono Nerd Font";
        polkit_agent = true;
      };

      plugins.enabled = [ "raycursive/niri-displays" ];

      bar.main.start = [
        "launcher"
        "wallpaper"
        "raycursive/niri-displays:bar"
        "workspaces"
      ];
    };
  };
}
