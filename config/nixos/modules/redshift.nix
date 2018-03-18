{ config, lib, pkgs, ... }:

let

in {

  services.redshift = {
    enable = true;
    provider = "geoclue2";
  };

}
