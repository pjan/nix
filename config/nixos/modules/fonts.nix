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
      font-awesome_5
      freefont_ttf
      google-fonts
      inconsolata
      powerline-fonts
      source-code-pro
    ];
    fontconfig.ultimate.enable = true;
  };

  i18n.consoleFont = "FiraCode-Retina";

}
