self: super:

let
  config = {
    packageOverrides = pkgs: rec {

    };
  };
  unstable = import <nixpkgs-unstable> { };
in {

  unstable = unstable.pkgs;

}

