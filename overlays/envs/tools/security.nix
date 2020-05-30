{ pkgs }:

pkgs.buildEnv {
  name = "security-tools";
  paths = with pkgs; [
		apg
    gnupg
    keybase
    kbfs
    paperkey
  ];
}
