{ config, lib, pkgs, ... }:

{

  programs.kitty = {
    enable = true;

    config = ''
      font_family      FiraCode-Retina
      font_size        10.0

      url_color #0087BD

      active_border_color #268bd2
      inactive_border_color #002b36

      active_tab_foreground #657b83
      active_tab_background #268bd2
      active_tab_font_style bold-italic
      inactive_tab_foreground #657b83
      inactive_tab_background #002b36
      inactive_tab_font_style normal

      foreground       #657b83
      background       #002b36

      background_opacity 1.0

      selection_foreground #002b36
      selection_background #657b83

      # The 16 terminal colors. There are 8 basic colors, each color has a dull and
      # bright version. You can also set the remaining colors from the 256 color table
      # as color16 to color256.

      # black
      color0   #073642
      color8   #002b36

      # red
      color1   #dc322f
      color9   #cb4b16

      # green
      color2   #859900
      color10  #586275

      # yellow
      color3   #b58900
      color11  #657b83

      # blue
      color4  #268bd2
      color12 #839496

      # magenta
      color5   #d33682
      color13  #6c71c4

      # cyan
      color6   #2aa198
      color14  #93a1a1

      # white
      color7   #eee8d5
      color15  #fdf6e3
    '';
  };

}

