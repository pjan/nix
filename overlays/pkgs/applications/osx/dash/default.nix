{ pkgs }:

with pkgs; osx.mkAppDerivation rec {
  name = "Dash";
  version = "4.1.3";
  sourceRoot = "Dash.app";
  src = fetchurl {
    url = "https://kapeli.com/downloads/v4/Dash.zip";
    sha256 = "073fzga9gra5rln7cixj50h7c6zgajhd2jibslkx2qrdbry67mc4";
  };
  description = "Api documentation browser and code snippet manager";
  homepage = https://kapeli.com/dash;
}

