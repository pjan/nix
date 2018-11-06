{ lib, config, pkgs, ... }:

{

  programs.curl = {
    enable = true;

    userAgent = "Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; Trident/5.0)";
    referer = ";auto";
    connectTimeout = 60;
  };

}
