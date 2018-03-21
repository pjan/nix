{ config, lib, pkgs, ... }:

let


in {

  system.stateVersion = "17.09";

  imports = [
    /etc/nixos/hardware-configuration.nix
    ../modules/gpg.nix
    ../modules/redshift.nix
    ../../shared/modules/neovim.nix
    ../../shared/modules/nix.nix
    ../../shared/modules/nixpkgs.nix
  ];


}
