self: super:

let
  myHaskellPackages = import ./envs/my-haskell-packages.nix self;
in {

  tools = {
    git        = self.callPackage ./envs/tools/git.nix      { };
    haskell    = self.callPackage ./envs/tools/haskell.nix  { };
    js         = self.callPackage ./envs/tools/js.nix       { };
    lang       = self.callPackage ./envs/tools/lang.nix     { };
    network    = self.callPackage ./envs/tools/network.nix  { };
    nix        = self.callPackage ./envs/tools/nix.nix      { };
    scala      = self.callPackage ./envs/tools/scala.nix    { };
    security   = self.callPackage ./envs/tools/security.nix { };
    system     = self.callPackage ./envs/tools/system.nix   { };
  };

  apps = {
    osx        = self.callPackage ./envs/apps/osx.nix       { };
  };

  scripts      = self.callPackage ./envs/scripts.nix        { };

  # envs = {
  #   ghc82          = self.haskell.envs.mkGhc82Env myHaskellPackages;
  #   ghc82-profiled = self.haskell.envs.mkGhc82ProfiledEnv myHaskellPackages;
  # };

}

