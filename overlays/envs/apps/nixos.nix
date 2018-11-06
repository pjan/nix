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
    # numix-solarized-gtk-theme
    pavucontrol
    playerctl
    rofi
    spotify
    tdesktop
    vlc
    wmctrl
    xcape
    skype
    gnome3.networkmanagerapplet
    idea.idea-community
    idea.idea-ultimate

    workspace
    browser

    pythonPackages.glances

    # paidy
    unstable.saml2aws
    awscli
    zoom-us
  ];
}

