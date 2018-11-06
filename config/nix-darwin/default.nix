{ config, lib, pkgs, ... }:

let

in {

  system.stateVersion = 2;
  services.activate-system.enable = true;
  services.nix-daemon.enable = true;

  require = [
    ../shared/modules/nixpkgs.nix
    ./modules/bash.nix
    ./modules/defaults.nix
    ./modules/gpg.nix
    ./modules/networking.nix
    ./modules/packages.nix
    ./modules/tmux.nix
    ../shared/modules/neovim.nix
    ../shared/modules/nix.nix
    ../shared/modules/nixpkgs.nix
  ];

}
