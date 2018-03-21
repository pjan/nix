{ config, lib, pkgs, ... }:

let

in {

  fonts = {
    enableFontDir = true;
    enableCoreFonts = true;
    enableGhostscriptFonts = true;
    fonts = with pkgs; [
      anonymousPro
      corefonts
      dejavu_fonts
      emojione
      fira-code
      freefont_ttf
      google-fonts
      inconsolata
      powerline-fonts
      source-code-pro
    ];
    fontconfig.ultimate.enable = true;
  };

}
