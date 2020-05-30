{ config, lib, pkgs, ... }:

let

in {

  environment = {
    systemPackages = with pkgs; [
      tools.git
      # haskell-tools
      tools.js
      tools.lang
      tools.network
      tools.nix
			tools.security
			tools.system
      # osx-apps
      # scala-tools
      # system-tools
    ];

    pathsToLink = [
      "/etc"
      "/lib"
      "/libexec"
      "/info"
      "/share"
      "/fonts"
      "/Applications"
    ];

  };

}
