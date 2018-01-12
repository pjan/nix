{ config, pkgs, ... }:

let
  home = builtins.getEnv "HOME";
in {

  launchd = {
    daemons = {
      cleanup = {
        command = "${home}/bin/cleanup -u";
       serviceConfig.StartInterval = 86400;
      };

      collect-garbage = {
        command = "${pkgs.nix}/bin/nix-collect-garbage --delete-older-than 14d";
        serviceConfig.StartInterval = 86400;
      };
    };
  };

}
