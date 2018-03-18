{ config, lib, pkgs, ... }:

with config; let

in {

  home.packages = with pkgs; [
    wget
  ];

  home.sessionVariables."WGETRC" = "${xdg.configHome}/wget/wgetrc";

  xdg.configFile."wget/wgetrc".source = ../../shared/config/wget/wgetrc;

}
