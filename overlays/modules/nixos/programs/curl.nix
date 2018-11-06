{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.programs.curl;

  package = with pkgs; symlinkJoin {
    name = "curl";
    buildInputs = [ makeWrapper ];
    paths = [ curl ];
    postBuild = ''
      wrapProgram "$out/bin/curl" \
      --set CURL_HOME "/etc/curl"
    '';
  };

in {

  options = {

    programs.curl = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Client URL
        '';
      };

      userAgent = mkOption {
        type = types.nullOr types.string;
        default = null;
        description = ''
          User agent string
        '';
      };

      referer = mkOption {
        type = types.nullOr types.string;
        default = null;
        description = ''
          Referer
        '';
      };

      connectTimeout = mkOption {
        type = types.nullOr types.int;
        default = null;
        description = ''
          Connection timeout in seconds
        '';
      };

      headers = mkOption {
        type = types.listOf types.string;
        default = [];
        description = ''
          Headers
        '';
      };

    };

  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ package ];

    environment.etc."curl/.curlrc".text = let
      headers = concatMapStrings (s: ''-H "${s}"'') cfg.headers;
    in ''
      ${optionalString (cfg.userAgent != null) ''user-agent = "${cfg.userAgent}"''}
      ${optionalString (cfg.referer != null) ''referer = "${cfg.referer}"''}
      ${optionalString (cfg.connectTimeout != null) ''connect-timeout = ${toString cfg.connectTimeout}''}
      ${headers}
    '';

  };

}

