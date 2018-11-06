{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.dunst;

  configFile = pkgs.writeText "dunstrc" ''
    ${cfg.config}
  '';

in {

  options = {
    services.dunst = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Dunst notification service.
        '';
      };

      config = mkOption {
        type = types.lines;
        default = "";
        description = ''
          Dunst configuration.
        '';
      };

      package = mkOption {
        type = types.package;
        default = pkgs.dunst;
        defaultText = "pkgs.dunst";
        example = literalExample "pkgs.dunst";
        description = ''
          Dunst derivation to use.
        '';
      };

    };
  };

  config = mkIf cfg.enable {
    systemd.user.services.dunst = {
      description = "Dunst notification service.";
      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.targe" ];
      serviceConfig = {
        ExecStart = "${cfg.package}/bin/dunst -config ${configFile}";
        RestartSec = 3;
        Restart = "always";
      };
    };

    environment.systemPackages = [ cfg.package ];
  };

}
