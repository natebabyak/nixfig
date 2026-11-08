{ lib }:

let
  theme = import ../theme.nix;
  rgb = builtins.mapAttrs (_: hex: {
    r = lib.fromHexString (builtins.substring 1 2 hex);
    g = lib.fromHexString (builtins.substring 3 2 hex);
    b = lib.fromHexString (builtins.substring 5 2 hex);
  }) theme.colors;
  colors = rgb // {
    accent = rgb.${theme.accent};
  };
in
{
  # Native Firefox Color format from catppuccin/firefox's theme generator.
  title = "Catppuccin ${theme.flavor} ${theme.accent}";
  colors = builtins.mapAttrs (_: name: colors.${name}) {
    toolbar = "base";
    toolbar_text = "text";
    frame = "crust";
    tab_background_text = "text";
    toolbar_field = "mantle";
    toolbar_field_text = "text";
    tab_line = "accent";
    popup = "base";
    popup_text = "text";
    button_background_active = "overlay0";
    frame_inactive = "crust";
    icons_attention = "accent";
    icons = "accent";
    ntp_background = "crust";
    ntp_text = "text";
    popup_border = "accent";
    popup_highlight_text = "text";
    popup_highlight = "overlay0";
    sidebar_border = "accent";
    sidebar_highlight_text = "crust";
    sidebar_highlight = "accent";
    sidebar_text = "text";
    sidebar = "base";
    tab_background_separator = "accent";
    tab_loading = "accent";
    tab_selected = "base";
    tab_text = "text";
    toolbar_bottom_separator = "base";
    toolbar_field_border_focus = "accent";
    toolbar_field_border = "base";
    toolbar_field_focus = "base";
    toolbar_field_highlight_text = "base";
    toolbar_field_highlight = "accent";
    toolbar_field_separator = "accent";
    toolbar_vertical_separator = "accent";
  };
  images = {
    additional_backgrounds = [ "./bg-000.svg" ];
    custom_backgrounds = [ ];
  };
}
