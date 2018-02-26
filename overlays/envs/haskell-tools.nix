{ pkgs }:

pkgs.buildEnv {
  name = "haskell-tools";
  paths = with pkgs; with haskellPackages; [
    cabal2nix
    cabal-install
    haskell-init
  ];
}
