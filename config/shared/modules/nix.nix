{ config, lib, pkgs, ... }:

let
  homedir = builtins.getEnv "HOME";
in {

  nix = {
    maxJobs = 4;
    buildCores = 4;
    trustedUsers = [ "root" "pjan" ];
    nixPath =
      [ "darwin-config=$HOME/src/nix/config/nix-darwin"
        "darwin=$HOME/src/nix/nix-darwin"
        "home-manager=$HOME/src/nix/home-manager"
        "home-manager-config=$HOME/src/nix/config/home-manager"
        "nixos-config=/etc/nixos/configuration.nix"
        # "nixos-config=$HOME/src/nix/config/nixos/io.pjan.aiko"
        "nixpkgs=$HOME/src/nix/nixpkgs"
        "nixpkgs-overlays=$HOME/src/nix/overlays"
      ];
    package = pkgs.nixUnstable;
    extraOptions = ''
      gc-keep-derivations = true
      gc-keep-outputs = true
      env-keep-derivations = true
    '';
  };

}
