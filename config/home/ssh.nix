{ config, pkgs, ... }:

with config; {

  programs.ssh = {
    enable = true;

    forwardAgent = true;
    compression = true;
    serverAliveInterval = 60;

    hashKnownHosts = true;
    #userKnownHostsFile = "${xdg.configHome}/ssh/known_hosts";

    matchBlocks = {
      basilisk = {
        hostname = "185.149.90.11";
        port = 41045;
      };
    };
  };

}
