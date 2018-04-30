{ config, lib, pkgs, ... }:

let

in {

  users = {
    mutableUsers = true;

    extraUsers = {

      pjan = {
        isNormalUser = true;
        group = "users";
        uid = 1000;
        extraGroups = [
          "audio"
          "disk"
          "docker"
          "networkmanager"
          "messagebus"
          "systemd-journal"
          "video"
          "wheel"
        ];
        hashedPassword = "$6$Js7GCT8T5jaT6$X02oM9b3WVWlp2TfAySQ7IuE7ipIXbo6s282Iw27p84vLNApHkbfgUsNjphSRBeYaTeC4F8kztJAFEQhUuOqi0";
      };

    };

  };

}

