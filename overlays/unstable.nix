self: super:

let
  unstable = import <nixpkgs-unstable> { };
in {

  unstable = unstable.pkgs;

}

