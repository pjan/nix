{ config, pkgs, ... }:

let

  homeDirectory = config.home.homeDirectory;

in rec {

  xdg = {
    enable = true;

    configHome = "${homeDirectory}/.config";
    dataHome   = "${homeDirectory}/.local/share";
    cacheHome  = "${homeDirectory}/.cache";
  };

  # programs.jq

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
    ./modules/git.nix
    ./modules/gpg.nix
    # ./modules/ssh.nix
    # ./modules/weechat.nix
    # ./modules/wget.nix
    ../shared/modules/nixpkgs.nix
  ];

	home.file = {
    ".curlrc".text = ''
      capath = ${pkgs.cacert}/etc/ssl/certs/
      cacert = ${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt

      user-agent = "Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; Trident/5.0)"
      referer = ";auto"
      connect-timeout = 60
    '';

    ".wgetrc".text = ''
      ca_directory = ${pkgs.cacert}/etc/ssl/certs/
      ca_certificate = ${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt
    '';
  };


  

}
