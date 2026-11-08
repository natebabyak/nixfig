{ lib, ... }:

let
  theme = import ../theme.nix;
in
{
  # Automatically theme supported applications as they are enabled.
  catppuccin = {
    enable = true;
    autoEnable = true;
    inherit (theme) flavor accent;
    cursors.enable = true;
    # Native Firefox Color settings avoid a build during Nix evaluation.
    firefox.enable = false;
    thunderbird.profile = "default";
  };

  gtk = {
    enable = true;
    gtk3.extraConfig.gtk-application-prefer-dark-theme = true;
    gtk4.extraConfig.gtk-application-prefer-dark-theme = true;
  };
  dconf.settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
  home.pointerCursor.gtk.enable = true;

  programs.noctalia.settings = {
    theme = {
      mode = "dark";
      source = "builtin";
      builtin = "Catppuccin";
    };
    wallpaper.default.path = "color:${theme.colors.base}";
  };

  # Firefox Color is required by the official Catppuccin Firefox integration.
  programs.firefox = {
    policies.ExtensionSettings."FirefoxColor@mozilla.com" = {
      install_url = "https://addons.mozilla.org/firefox/downloads/latest/firefox-color/latest.xpi";
      installation_mode = "normal_installed";
    };
    profiles.default = {
      isDefault = true;
      extensions.settings."FirefoxColor@mozilla.com" = {
        force = true;
        settings = {
          firstRunDone = true;
          theme = import ./firefox-theme.nix { inherit lib; };
        };
      };
    };
  };

  programs.thunderbird.profiles.default = {
    isDefault = true;
    settings."extensions.activeThemeID" = theme.thunderbirdThemeId;
  };
}
