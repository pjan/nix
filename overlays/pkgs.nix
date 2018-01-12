self: super:

rec {

  ghi  = super.callPackage ./pkgs/applications/version-management/git-and-tools/ghi  { };
  #gist = super.callPackage ./pkgs/applications/version-management/git-and-tools/gist { };

}
