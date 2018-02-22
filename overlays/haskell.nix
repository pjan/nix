self: super:

with super.haskell.lib; let

  mkPackages = haskellPackages: haskellPackageOverrides: haskellPackages.override {
    overrides = haskellPackageOverrides;
  };

  ghc82PackageOverrides = profiling: self: super:
    {
      blaze-builder-enumerator = doJailbreak super.blaze-builder-enumerator;
      codex                    = doJailbreak super.codex;
      compressed               = doJailbreak super.compressed;
      commodities              = doJailbreak super.commodities;
      consistent               = dontCheck (doJailbreak super.consistent);
      hierarchy                = doJailbreak super.hierarchy;
      text-show                = dontCheck super.text-show;
      pipes-binary             = doJailbreak super.pipes-binary;
      pipes-files              = dontCheck (doJailbreak super.pipes-files);
      pipes-zlib               = dontCheck (doJailbreak super.pipes-zlib);
      recursors                = doJailbreak super.recursors;
      time-recurrence          = doJailbreak super.time-recurrence;

      recurseForDerivations = true;

      mkDerivation = args: super.mkDerivation (args // {
        enableLibraryProfiling = profiling;
        enableExecutableProfiling = false;
      });

    };

  ghc82Packages = mkPackages self.haskell.packages.ghc822 (ghc82PackageOverrides false);
  ghc82ProfiledPackages = mkPackages self.haskell.packages.ghc822 (ghc82PackageOverrides true);

  mkGhc82Env = myHaskellPackages: super.myEnvFun {
    name = "ghc82Env";
    buildInputs = with ghc82Packages; [
      (ghcWithHoogle myHaskellPackages)
    ];
  };

  mkGhc82ProfiledEnv = myHaskellPackages: super.myEnvFun {
    name = "ghc82Env";
    buildInputs = with ghc82ProfiledPackages; [
      (ghcWithHoogle myHaskellPackages)
    ];
  };

in rec {

  haskell = super.haskell // {

    envs = {
      inherit mkGhc82Env mkGhc82ProfiledEnv;
    };

  };

}

