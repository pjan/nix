{ config, lib, pkgs, ... }:

let

in {

  nix = {
    maxJobs = 4;
    buildCores = 4;
    trustedUsers = [ "root" "pjan" ];
    nixPath =
      [ "darwin-config=/data/src/nix/config/nix-darwin"
        "darwin=/data/src/nix/nix-darwin"
        "home-manager=/data/src/nix/home-manager"
        "home-manager-config=/data/src/nix/config/home-manager"
        "nixos-config=/etc/nixos/configuration.nix"
        # "nixos-config=/data/src/nix/config/nixos/io.pjan.aiko"
        "nixpkgs=/data/src/nix/nixpkgs"
        "nixpkgs-overlays=/data/src/nix/overlays"
      ];
    package = pkgs.nixUnstable;
    extraOptions = ''
      gc-keep-derivations = true
      gc-keep-outputs = true
      env-keep-derivations = true
    '';
  };

}
