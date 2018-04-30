{ pkgs }:

pkgs.buildEnv {
  name = "osx-apps";
  paths = with pkgs.osx; [
    dash
    pinentry_mac
    vlc
  ];
}

