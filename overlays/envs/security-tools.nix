{ pkgs }:

pkgs.buildEnv {
  name = "security-tools";
  paths = with pkgs; [
    keybase
    kbfs
    paperkey
    pinentry_mac
  ];
}
