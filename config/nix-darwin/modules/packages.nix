{ config, lib, pkgs, ... }:

let

in {

  environment = {
    systemPackages = with pkgs; [
      git-tools
      haskell-tools
      js-tools
      lang-tools
      network-tools
      nix-tools
      osx-apps
      scala-tools
      security-tools
      system-tools
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
