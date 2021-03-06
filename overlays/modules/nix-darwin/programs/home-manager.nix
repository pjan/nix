{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.programs.home-manager;

  package = pkgs.home-manager;

in {

  options = {

    programs.home-manager = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Configure home-manager
        '';
      };

    };

  };

  config = mkIf cfg.enable {

    environment.systemPackages = [ package ];

    programs.shells.bash.shellInitExtra = ''
      source "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
    '';

  };


}