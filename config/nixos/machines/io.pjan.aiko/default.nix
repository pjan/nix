{ config, lib, pkgs, ... }:

let

in {

  imports = import (<nixpkgs-overlays> + "/modules/nixos") ++ [
    ../../hardware/mbp.nix
    ../../modules/bash.nix
    ../../modules/compton.nix
    ../../modules/curl.nix
    ../../modules/dunst.nix
    ../../modules/fonts.nix
    ../../modules/git.nix
    ../../modules/gpg.nix
    ../../modules/home-manager.nix
    ../../modules/kitty.nix
    ../../modules/networking.nix
    ../../modules/packages.nix
    ../../modules/redshift.nix
    ../../modules/udiskie.nix
    ../../modules/virtualisation.nix
    ../../modules/xserver.nix
    ../../../shared/modules/neovim.nix
    ../../../shared/modules/nix.nix
    ../../../shared/modules/nixpkgs.nix
    ../../users/pjan.nix
  ];

  networking.hostName = "aiko";

  time.timeZone = "Asia/Tokyo";

}

