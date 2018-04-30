{ pkgs }:

pkgs.buildEnv {
  name = "nixos-apps";
  paths = with pkgs; [
    chromium
    networkmanager
    rofi
    rxvt_unicode
    spotify
    vlc
    xcape
  ];
}

