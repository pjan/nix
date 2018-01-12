{ config, pkgs, ... }:

let
  home = builtins.getEnv "HOME";
in {

  environment = {
    systemPackages = with pkgs; [
      git-tools
      haskell-tools
      lang-tools
      network-tools
      nix-tools
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
      EDITOR        = "vim";
      GIT_PAGER     = "less";
      LC_CTYPE      = "en_US.UTF-8";
      LESS          = "-FRSXM";
      LESSCHARSET   = "utf-8";
      PAGER         = "less";
    };
  };

  networking = {
    #hostName = "AKIRA";
    networkservices = [ "Ethernet" "Wi-Fi" ];
    dns = [ "8.8.8.8" "8.8.4.4" "2001:4860:4860::8888" "2001:4860:4860::8844" ];
  };

}
