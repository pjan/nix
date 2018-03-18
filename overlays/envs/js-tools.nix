{ pkgs }:

pkgs.buildEnv {
  name = "js-tools";
  paths = with pkgs; [
    jq
    nodejs
    nodePackages.eslint
    nodePackages.csslint
    # jquery
  ];
}

