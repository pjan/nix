{ cfg, lib, pkgs, ... }:

let

  workVPN = name: {
    config = ''
      client
      config /root/nixos/openvpn/${name}.ovpn
    '';
    updateResolvConf = true;
    autoStart = false;
    up = ''
      mkdir -p /var/run/openvpn
      touch /var/run/openvpn/${name}
    '';
    down = ''
      rm /var/run/openvpn/${name}
    '';
  };

  seedboxesVPN = name: {
    config = ''
      config /root/nixos/openvpn/${name}.ovpn
      auth-user-pass /root/nixos/openvpn/seedboxes-login.conf
    '';
    updateResolvConf = true;
    autoStart = false;
    up = ''
      mkdir -p /var/run/openvpn
      touch /var/run/openvpn/${name}
    '';
    down = ''
      rm /var/run/openvpn/${name}
    '';
  };

in {

  networking = {
    networkmanager = {
      enable = true;
      insertNameservers = [ "8.8.8.8" "8.8.4.4" ];
    };
    nameservers = [ "8.8.8.8" "8.8.4.4" ];

    # Open Chromecast-related ports
    firewall.allowedTCPPorts = [ 5556 5558 ];
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

  services.keybase = {
    enable = true;
  };

  services.openvpn = {

    servers = {
      "io.paidy.production" = workVPN "io.paidy.production";
      "io.paidy.uat"        = workVPN "io.paidy.uat";

      "cc.seedboxes.uk" = seedboxesVPN "cc.seedboxes.uk";
      "cc.seedboxes.nl" = seedboxesVPN "cc.seedboxes.nl";
      "cc.seedboxes.fr" = seedboxesVPN "cc.seedboxes.fr";
      "cc.seedboxes.us" = seedboxesVPN "cc.seedboxes.us";
      "cc.seedboxes.sg" = seedboxesVPN "cc.seedboxes.sg";
      "cc.seedboxes.ca" = seedboxesVPN "cc.seedboxes.ca";
      "cc.seedboxes.de" = seedboxesVPN "cc.seedboxes.de";
    };

  };

}

