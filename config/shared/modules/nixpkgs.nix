{ config, lib, pkgs, ... }:

let

in {

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowBroken = true;
      allowUnsupportedSystem = false;

      permittedInsecurePackages = [ ];
    };

    overlays = let path = ../../.. + "/overlays";
    in with builtins;
    map (n: import (path + ("/" + n))) (filter (n:
      match ".*\\.nix" n != null
      || pathExists (path + ("/" + n + "/default.nix")))
      (attrNames (readDir path)));
  };

}
