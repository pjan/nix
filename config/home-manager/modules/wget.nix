{ config, ... }:

with config; {

  home.sessionVariables."WGETRC" = "${xdg.configHome}/wget/wgetrc";

  xdg.configFile."wget/wgetrc".source = ../../shared/config/wget/wgetrc;

}
