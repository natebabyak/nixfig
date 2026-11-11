{
  programs.noctalia = {
    enable = true;
    settings = {
      shell = {
        font_family = "JetBrainsMono Nerd Font";
        polkit_agent = true;
      };

      plugins.enabled = [
        "raycursive/niri-displays"
        "noctalia/wallhaven"
      ];

      bar.default.start = [
        "launcher"
        "wallpaper"
        "noctalia/wallhaven:wallhaven"
        "raycursive/niri-displays:bar"
        "workspaces"
      ];
    };
  };
}
