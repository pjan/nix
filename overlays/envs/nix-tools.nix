{ pkgs }:

pkgs.buildEnv {
  name = "nix-tools";
  paths = with pkgs; [
    nix
    nix-index
    nix-info
    nix-prefetch-scripts
    nix-repl
  ];
}
