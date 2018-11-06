{ config, lib, pkgs, ... }:

let

in {

  environment.systemPackages = with pkgs; [
    tools.git
    tools.haskell
    tools.network
    tools.nix
    tools.security
    tools.system

    apps.nixos
  ];

}

