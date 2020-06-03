{ config, lib, pkgs, ... }:

let

in {

  system.stateVersion = 2;
  services.activate-system.enable = true;
  services.nix-daemon.enable = false;

  imports = import (<nix-overlays> + "/modules/nix-darwin") ++ [
    ./modules/bash.nix
    ./modules/defaults.nix
    # ./modules/gpg.nix
    ./modules/networking.nix
    ./modules/neovim.nix
    ./modules/nix.nix
    ./modules/packages.nix
    ./modules/tmux.nix
    ../shared/modules/nixpkgs.nix
  ];

}
