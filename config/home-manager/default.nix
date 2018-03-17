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
    EDITOR        = "${pkgs.vim}/bin/vim";
  };

  imports = [
    ./modules/nixpkgs.nix
    # Applications
    ./modules/bash.nix
    ./modules/curl.nix
    ./modules/gpg.nix
    ./modules/git.nix
    ./modules/ssh.nix
    ./modules/weechat.nix
    ./modules/wget.nix
  ];

}
