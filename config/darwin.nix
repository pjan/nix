{ pkgs, ... }: {

  system.stateVersion = 2;
  services.activate-system.enable = true;

  require = [
    ./darwin/nix.nix
    ./darwin/aliases.nix
    ./darwin/defaults.nix
    ./darwin/launchd.nix
    ./darwin/system.nix
    # Applications
    ./darwin/fish.nix
    ./darwin/tmux.nix
    ./darwin/vim.nix
  ];

}
