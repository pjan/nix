{ pkgs }:

pkgs.buildEnv {
  name = "scripts";
  paths = with pkgs; [
    abspath
  ];
}

