{ config, ... }:

with config; {

  home.sessionVariables."CURL_HOME" = "${xdg.configHome}/curl/curlrc";

  xdg.configFile."curl/curlrc".source = ../shared/config/curl/curlrc;

}
