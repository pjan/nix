{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.wallpaper;

  imageDir = cfg.directory;

in {

  options = {

    services.wallpaper = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Wallpaper service.
        '';
      };

      directory = mkOption {
        type = types.str;
        description = ''
          The diractory with images from which the wallpaper should be chosen.
        '';
      };

      interval = mkOption {
        type = types.nullOr types.int;
        default = null;
        description = ''
          The duration between changing the desktop's wallpaper. If null,
          it will keep the background set when logging in.

          Time set in seconds.
        '';
      };

    };

  };

  config = mkIf cfg.enable (mkMerge [
    {
      systemd.user.services.wallpaper = {
        description = "Set wallpaper using feh";
        wantedBy = [ "graphical-session.target" ];
        partOf = [ "graphical-session.target" ];
        after = [ "graphical-session-pre.target" ];
        serviceConfig = {
          ExecStart = "${pkgs.feh}/bin/feh --randomize --bg-fill '${imageDir}'";
          IOSchedulingClass = "idle";
          Type = "oneshot";
        };
      };
    }

    (mkIf (cfg.interval != null) {
      systemd.user.timers.wallpaper = {
        description = "Set wallpaper using feh";
        wantedBy = [ "timers.target" ];
        timerConfig = {
          OnUnitActiveSec = "${toString cfg.interval}";
        };
      };
    })

  ]);

}

