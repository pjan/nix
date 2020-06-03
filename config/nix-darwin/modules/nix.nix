{ config, lib, pkgs, ... }:

let

in {

  nix = {
    maxJobs = 4;
    buildCores = 4;
    trustedUsers = [ "@admin" "pjan" ];
    binaryCaches = [
      https://cache.nixos.org/
      https://pjan.cachix.org/
    ];
		useDaemon = false;
    binaryCachePublicKeys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "pjan.cachix.org-1:APBhNys++s+B2mfQsTp5X1CiMpatiGxY0EpCMSLqvVg="
    ];
    nixPath =
      [ "darwin-config=$HOME/Development/nix/config/nix-darwin"
        "darwin=$HOME/Development/nix/nix-darwin"
        "home-manager=$HOME/Development/nix/home-manager"
        "home-manager-config=$HOME/Development/nix/config/home-manager"
        "nixpkgs=$HOME/Development/nix/nixpkgs-unstable"
        "nixpkgs-stable=$HOME/Development/nix/nixpkgs-stable"
        "nix-overlays=$HOME/Development/nix/overlays"
      ];
    package = pkgs.nixStable;
    extraOptions = ''
      gc-keep-derivations = true
      gc-keep-outputs = true
      env-keep-derivations = true
    '';
  };

	programs.nix-index.enable = true;

}

