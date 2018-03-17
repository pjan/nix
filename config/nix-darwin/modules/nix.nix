{ pkgs, ... }:

let
  homedir = builtins.getEnv "HOME";
in {

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowBroken = true;
    };

    overlays =
      let
        path = ../../.. + "/overlays";
      in with builtins;
      map (n: import (path + ("/" + n)))
          (filter (n: match ".*\\.nix" n != null ||
                      pathExists (path + ("/" + n + "/default.nix")))
                      (attrNames (readDir path)));
  };

  nix = {
    maxJobs = 4;
    buildCores = 4;
    trustedUsers = [ "root" "pjan" ];
    nixPath =
      [ "darwin-config=$HOME/src/nix/config/nix-darwin"
        "darwin=$HOME/src/nix/nix-darwin"
        "home-manager=$HOME/src/nix/home-manager"
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

  services.nix-daemon.enable = true;

  environment.variables.HOME_MANAGER_CONFIG = "${homedir}/src/nix/config/home-manager";

}
