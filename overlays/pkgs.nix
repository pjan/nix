self: super:

rec {

  ghi = super.callPackage ./pkgs/applications/version-management/git-and-tools/ghi { };

  gist = super.callPackage ./pkgs/applications/version-management/git-and-tools/gist { };

  home-manager = super.callPackage ../home-manager/home-manager {
    path = toString ../home-manager;
  };
  tmuxPlugins = super.recurseIntoAttrs (super.callPackage ./pkgs/misc/tmux-plugins { });

  # OSX Apps
  dash        = super.callPackage ./pkgs/applications/osx/dash { };
  vlc         = super.callPackage ./pkgs/applications/osx/vlc { };

}
