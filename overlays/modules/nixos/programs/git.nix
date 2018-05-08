{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.programs.git;

  package = with pkgs;
    if (cfg.config != null)
    then symlinkJoin {
      name = "git";
      buildInputs = [ makeWrapper ];
      paths = [ git ];
      postBuild = ''
        wrapProgram "$out/bin/git" \
        --set GIT_CONFIG "/etc/git/git.conf
      '';
    }
    else git;

in {

  options = {

    programs.git = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Git VCS.
        '';
      };

      config = mkOption {
        type = types.nullOr types.lines;
        default = null;
        description = ''
          Git configuration.
        '';
      };

    };

  };

  config = mkIf cfg.enable (mkMerge [
    (mkIf (cfg.config != null) {

    })

    {
      environment.systemPackages = [ package ];
    }
  ]);



}

