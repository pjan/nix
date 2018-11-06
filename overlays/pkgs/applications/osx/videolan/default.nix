{ pkgs }:

with pkgs; osx.mkAppDerivation rec {
  name = "videolan";
  src = fetchurl {
    url = "https://get.videolan.org/vlc/${meta.version}/macosx/vlc-${meta.version}.dmg";
    sha256 = "09x0sbzrs1sknw6bd549zgfq15ir7q6hflqyn4x71ib6qljy01j4";
  };
  sourceRoot = "VLC.app";
  meta = {
    version = "2.2.8";
    description = "Free and open source cross-platform multimedia player";
    homepage = https://www.videolan.org/vlc;
  };
}

