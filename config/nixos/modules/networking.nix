 { cfg, lib, pkgs, ... }:

 {

  networking = {
    networkmanager = {
      enable = true;
      insertNameservers = [ "8.8.8.8" "8.8.4.4" ];
    };
    nameservers = [ "8.8.8.8" "8.8.4.4" ];
  };

  services.avahi = {
    enable = true;
    nssmdns = true;
  };

  services.dnsmasq = {
    enable = true;
    servers = [
      "8.8.4.4"
      "8.8.8.8"
    ];
  };

 }

