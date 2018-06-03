{ pkgs }:

pkgs.buildEnv {
  name = "nixos-apps";
  paths = with pkgs; [
    chromium
    dex
    evince
    firefox
    gnome3.zenity
    lightlocker
    lxappearance
    networkmanager
    numix-solarized-gtk-theme
    pavucontrol
    playerctl
    rofi
    spotify
    vlc
    wmctrl
    xcape
    skype

    workspace
    browser

    pythonPackages.glances
  ];
}

