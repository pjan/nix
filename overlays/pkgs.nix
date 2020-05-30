self: super:

rec {

  ghi           = super.callPackage ./pkgs/applications/version-management/git-and-tools/ghi { };
  home-manager  = super.callPackage ../home-manager/home-manager {
    path = toString ../home-manager;
  };
  haskell-init  = super.callPackage ./pkgs/development/haskell/haskell-init { };
  tmuxPlugins   = super.recurseIntoAttrs (super.callPackage ./pkgs/misc/tmux-plugins { });

  haskell-shell = super.callPackage ./pkgs/tools/haskell-shell { };

  # OSX Apps
  osx = {
    dash       = super.callPackage ./pkgs/applications/osx/dash { };
    vlc        = super.callPackage ./pkgs/applications/osx/vlc { };
  };

  # haskellPackages = super.haskellPackages.override {
  #   overrides = self': super': {
  #     taffybar = (import /home/pjan/.config/taffybar).my-taffybar;
  #   };
  # };


  # haskellPackages = super.haskellPackages.override {
  #       overrides = self': super': {
  #         gi-dbusmenugtk3 = self.haskell.lib.addPkgconfigDepend super'.gi-dbusmenugtk3 self.gtk3;
  #         taffybar = super'.taffybar.overrideDerivation (drv: {
  #           strictDeps = true;
  #           src = self.fetchFromGitHub {
  #             owner = "taffybar";
  #             repo = "taffybar";
  #             rev = "v2.1.1";
  #             sha256 = "12g9i0wbh4i66vjhwzcawb27r9pm44z3la4693s6j21cig521dqq";
  #           };
  #         });
  #       };
  #     };

}

