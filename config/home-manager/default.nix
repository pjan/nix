{ config, pkgs, ... }:

let
  homedir = config.home.homeDirectory;
in rec {

  xdg = {
    enable = true;

    configHome = "${homedir}/.config";
    dataHome   = "${homedir}/.local/share";
    cacheHome  = "${homedir}/.cache";



  };

  home.sessionVariables = {
    CABAL_CONFIG  = "${xdg.configHome}/cabal/config";
    LC_CTYPE      = "en_US.UTF-8";
    LESS          = "-FRSXM";
    LESSCHARSET   = "utf-8";
    PAGER         = "less";
    LESSHISTFILE  = "${xdg.cacheHome}/less/history";
    PARALLEL_HOME = "${xdg.cacheHome}/parallel";
  };

  imports = [
    # ./modules/ssh.nix
    # ./modules/weechat.nix
    # ./modules/wget.nix
    ../shared/modules/nixpkgs.nix
  ];

}
