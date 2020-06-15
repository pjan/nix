self: super:

rec {

  # applications/version-management
  ghi           = super.callPackage ./pkgs/applications/version-management/git-and-tools/ghi { };

  #
  jupyterWith   = super.callPackage ./pkgs/applications/editors/jupyterWith { };

  # development/haskell-modules
  haskell-init  = super.callPackage ./pkgs/development/haskell-modules/haskell-init { };
  haskell-shell = super.callPackage ./pkgs/development/haskell-modules/haskell-shell { };
  
  # misc
  tmuxPlugins   = super.recurseIntoAttrs (super.callPackage ./pkgs/misc/tmux-plugins { });

  # scripts
  abspath       = super.callPackage ./pkgs/scripts/abspath { };
  proxy-toggle  = super.callPackage ./pkgs/scripts/proxy-toggle { };

  # Overrides
  home-manager  = super.callPackage ../home-manager/home-manager {
    path = toString ../home-manager;
  };
  torsocks      = super.callPackage ./pkgs/security/tor/torsocks.nix { };

  # OSX Apps
  # osx = {
  #   dash       = super.callPackage ./pkgs/applications/osx/dash { };
  #   vlc        = super.callPackage ./pkgs/applications/osx/vlc { };
  # };

}
