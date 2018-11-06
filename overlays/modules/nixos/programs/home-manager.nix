{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.programs.home-manager;

  package =
    if (cfg.configPath != null)
    then pkgs.writeShellScriptBin "home-manager" ''
      ${pkgs.home-manager}/bin/home-manager -f ${toString cfg.configPath} "$@"
    ''
    else pkgs.home-manager;

in {

  options = {

    programs.home-manager = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Home manager.
        '';
      };

      configPath = mkOption {
        type = types.nullOr types.path;
        default = null;
        description = ''
          Path to configuration.
        '';
      };

    };

  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ package ];
  };

}

