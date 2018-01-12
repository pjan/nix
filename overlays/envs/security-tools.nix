{ pkgs }:

pkgs.buildEnv {
  name = "security-tools";
  paths = with pkgs; [
    gnupg
    keybase
    kbfs
    paperkey
    pinentry_mac
  ];
}
