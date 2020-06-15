{ pkgs }:

pkgs.buildEnv {
  name = "nix-tools";
  paths = with pkgs; [
		cachix
    home-manager
    nix
    nix-bash-completions
    nix-index
    nix-info
    nix-prefetch-scripts
    nixfmt
  ];
}
