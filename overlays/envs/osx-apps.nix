{ pkgs }:

pkgs.buildEnv {
  name = "osx-apps";
  paths = with pkgs; [
    dash
    vlc
  ];
}

