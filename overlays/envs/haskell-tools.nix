{ pkgs }:

pkgs.buildEnv {
  name = "haskell-tools";
  paths = with pkgs; [
    cabal2nix
    cabal-install
  ];
}
