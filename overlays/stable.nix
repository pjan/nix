self: super:

let
  config = {
    packageOverrides = pkgs: rec {

    };
  };
  stable = import <nixpkgs-stable> { };
in {

  stable = stable.pkgs;

}

