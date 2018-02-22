self: super:

let
  myHaskellPackages = import ./envs/my-haskell-packages.nix self;
in {

  git-tools        = self.callPackage ./envs/git-tools.nix      { };
  haskell-tools    = self.callPackage ./envs/haskell-tools.nix  { };
  js-tools         = self.callPackage ./envs/js-tools.nix       { };
  lang-tools       = self.callPackage ./envs/lang-tools.nix     { };
  network-tools    = self.callPackage ./envs/network-tools.nix  { };
  nix-tools        = self.callPackage ./envs/nix-tools.nix      { };
  osx-apps         = self.callPackage ./envs/osx-apps.nix       { };
  scala-tools      = self.callPackage ./envs/scala-tools.nix    { };
  security-tools   = self.callPackage ./envs/security-tools.nix { };
  system-tools     = self.callPackage ./envs/system-tools.nix   { };

  envs = {
    ghc82          = self.haskell.envs.mkGhc82Env myHaskellPackages;
    ghc82-profiled = self.haskell.envs.mkGhc82ProfiledEnv myHaskellPackages;
  };

}

