{ config, lib, pkgs, ... }:

let

in {

  environment = {
    systemPackages = with pkgs; [
      tools.git
      tools.js
      tools.lang
      tools.network
      tools.nix
			tools.security
			tools.system
      scripts
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
