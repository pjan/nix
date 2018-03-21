{ config, lib, pkgs, ... }:

let

in {

  security = {

    sudo = {
      enable = true;
      extraConfig = ''
        ALL ALL = (root) NOPASSWD: ${pkgs.iw}/bin/iw
        ALL ALL = (root) NOPASSWD: ${pkgs.light}/bin/light
        ALL ALL = (root) NOPASSWD: ${pkgs.systemd}/bin/shutdown
        ALL ALL = (root) NOPASSWD: ${pkgs.systemd}/bin/reboot
      '';
    };

  };

}
