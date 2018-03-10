{ pkgs, ... }: {

  system.stateVersion = 2;
  services.activate-system.enable = true;

  require = [
    ./darwin/nix.nix
    ./darwin/defaults.nix
    ./darwin/system.nix
    # Applications
    ./darwin/bash.nix
    ./darwin/fish.nix
    ./darwin/tmux.nix
    ./darwin/vim.nix
  ];

}
