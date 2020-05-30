{ config, lib, pkgs, ... }:

let

in {

  system.stateVersion = 4;
  services.activate-system.enable = true;
  services.nix-daemon.enable = false;

  require = [
    ./modules/bash.nix
    ./modules/defaults.nix
    # ./modules/gpg.nix
    ./modules/networking.nix
    ./modules/neovim.nix
    ./modules/nix.nix
    ./modules/packages.nix
    # ./modules/tmux.nix
    ../shared/modules/nixpkgs.nix
  ];

}
