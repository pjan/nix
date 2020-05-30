self: super:

{ }
# with super.haskell.lib; let

#   myHaskellPackages = import ./envs/my-haskell-packages.nix super;

#   mkPackages = haskellPackages: haskellPackageOverrides: haskellPackages.override {
#     overrides = self: super: haskellPackageOverrides (myPackageDefs super) self super;
#   };

#   myPackageDefs = super: {};
#     # with super; rec {
#     #   lushtags = super.callPackage /data/src/lushtags { };
#     # };

#   ghcPackageOverrides = ghcVersion: profiling: myPackages: self: super:
#     myPackages // {
#       blaze-builder-enumerator = doJailbreak super.blaze-builder-enumerator;
#       codex                    = doJailbreak super.codex;
#       compressed               = doJailbreak super.compressed;
#       commodities              = doJailbreak super.commodities;
#       consistent               = dontCheck (doJailbreak super.consistent);
#       hedgehog-checkers        = doJailbreak super.hedgehog-checkers;
#       hierarchy                = doJailbreak super.hierarchy;
#       text-show                = dontCheck super.text-show;
#       pipes-binary             = doJailbreak super.pipes-binary;
#       pipes-files              = dontCheck (doJailbreak super.pipes-files);
#       pipes-zlib               = dontCheck (doJailbreak super.pipes-zlib);
#       recursors                = doJailbreak super.recursors;
#       time-recurrence          = doJailbreak super.time-recurrence;

#       mkDerivation = args: super.mkDerivation (args // {
#         enableLibraryProfiling = profiling;
#         enableExecutableProfiling = false;
#       });

#     };

#   ghc82Packages = mkPackages super.haskell.packages.ghc822 (ghcPackageOverrides "ghc822" false);
#   ghc82ProfiledPackages = mkPackages super.haskell.packages.ghc822 (ghcPackageOverrides "ghc822" true);

#   mkGhc82Env = myHaskellPackages: super.myEnvFun {
#     name = "ghc82Env";
#     buildInputs = with ghc82Packages; [
#       (ghcWithHoogle myHaskellPackages)
#     ];
#   };

#   mkGhc82ProfiledEnv = myHaskellPackages: super.myEnvFun {
#     name = "ghc82Env";
#     buildInputs = with ghc82ProfiledPackages; [
#       (ghcWithPackages myHaskellPackages)
#     ];
#   };

# in {

#   haskellPackages = self.haskell.packages.ghc822;

#   haskell = super.haskell // {

#     envs = {
#       ghc82         = mkGhc82Env (myHaskellPackages 8.2);
#       ghc82Profiled = mkGhc82ProfiledEnv (myHaskellPackages 8.2);
#     };

#   };

# }

