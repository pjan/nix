self: super:

rec {

  ghi          = super.callPackage ./pkgs/applications/version-management/git-and-tools/ghi  { };
  gist         = super.callPackage ./pkgs/applications/version-management/git-and-tools/gist { };
  home-manager = super.callPackage ../home-manager/home-manager {
    path = toString ../home-manager;
  };

}
