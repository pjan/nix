{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.udiskie;

  commandArgs = 
    concatStringsSep " " (
      map (opt: "-" + opt) [
        (if cfg.automount then "a" else "A")
        (if cfg.notify then "n" else "N")
        ({ always = "t"; auto = "s"; never = "T"; }.${cfg.tray})
      ]
    );

in {

  options = {

    services.udiskie = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          udiskie mount daemon
        '';
      };

      package = mkOption {
        type = types.package;
        default = pkgs.udiskie;
        defaultText = "pkgs.udiskie";
        example = literalExample "pkgs.udiskie";
        description = ''
          Udiskie derivation to use.
        '';
      };

      automount = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Whether udiskie should automatically mount new devices.
        '';
      };

      notify = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Whether udiskie should show pop-up notifications.
        '';
      };

      tray = mkOption {
        type = types.enum [ "always" "auto" "never" ];
        default = "auto";
        description = ''
          Whether udiskie should display a tray icon.
        '';
      };

    };

  };

  config = mkIf cfg.enable {
    systemd.user.services.udiskie = {
      description = "Udiskie mount daemon";
      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      after = [ "graphical-session-pre.target" ];
      serviceConfig = {
        ExecStart = "${cfg.package}/bin/udiskie -2 ${commandArgs}";
        RestartSec = 5;
        Restart = "always";
      };
    };

    environment.systemPackages = [ cfg.package ];
  };

}

