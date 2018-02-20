{ pkgs }:

with pkgs; osx.mkAppDerivation rec {
  name = "VLC";
  version = "2.2.8";
  src = fetchurl {
    url = "https://get.videolan.org/vlc/${version}/macosx/vlc-${version}.dmg";
    sha256 = "09x0sbzrs1sknw6bd549zgfq15ir7q6hflqyn4x71ib6qljy01j4";
  };
  sourceRoot = "VLC.app";
  description = "Free and open source cross-platform multimedia player";
  homepage = https://www.videolan.org/vlc;
}

