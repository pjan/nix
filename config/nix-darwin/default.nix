{ pkgs, ... }: {

  system.stateVersion = 2;
  services.activate-system.enable = true;

  require = [
    ./modules/nix.nix
    ./modules/defaults.nix
    ./modules/system.nix
    # Applications
    ./modules/bash.nix
    ./modules/fish.nix
    ./modules/tmux.nix
    ./modules/vim.nix
  ];

}
