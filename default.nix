{ nixpkgs       ? <nixpkgs>
, configuration ? <darwin-config>
, system        ? builtins.currentSystem
, pkgs          ? import nixpkgs { inherit system; }
, version       ? "0.0"
}:

let

  darwin = import <darwin> { inherit nixpkgs configuration system pkgs; };

  home-manager = import ./home-manager/home-manager/home-manager.nix {
    inherit pkgs;
    confPath = ./config/home-manager;
    confAttr = "";
  };

in {
  nix-darwin = darwin.system;
  home-manager = home-manager.activationPackage;
}