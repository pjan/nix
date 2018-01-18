{ pkgs }:

with pkgs; buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "gist";
  version = "4.6.2";
  source.sha256 = "2bc63a0b96e56d1d95b1410854148f6fb400c2904aecaaad8a4aa02426413c7f";
  buildInputs = [bundler];
}
