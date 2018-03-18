{ config, lib, pkgs, ... }:

with config; let

in {

  home.packages = with pkgs; [
    curl
  ];

  home.sessionVariables."CURL_HOME" = "${xdg.configHome}/curl/curlrc";

  xdg.configFile."curl/curlrc".source = ../../shared/config/curl/curlrc;

}
