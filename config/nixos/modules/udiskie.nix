{ config, lib, pkgs, ... }:

let

in {

  services.udiskie = {
    enable = true;
    tray = "never";
  };

}

