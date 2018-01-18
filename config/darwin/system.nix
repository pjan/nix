{ config, pkgs, ... }:

let
  homedir = builtins.getEnv "HOME";
in {

  environment = {
    systemPackages = with pkgs; [
      git-tools
      haskell-tools
      js-tools
      lang-tools
      network-tools
      nix-tools
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
    ];

    variables = {
      HOME_MANAGER_CONFIG = "${homedir}/src/nix/config/home.nix";
    };
  };

  networking = {
    #hostName = "AKIRA";
    knownNetworkServices = [ "Ethernet" "Wi-Fi" ];
    dns = [ "8.8.8.8" "8.8.4.4" "2001:4860:4860::8888" "2001:4860:4860::8844" ];
  };

}
