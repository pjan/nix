{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.taffybar;

  taffybar = package.override {
    packages = self: cfg.extraPackages self;
  };

in {

  options = {
    services.taffybar = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Taffybar.
        '';
      };

      package = mkOption {
        type = types.package;
        default = pkgs.taffybar;
        defaultText = "pkgs.taffybar";
        example = literalExample "pkgs.taffybar";
        description = ''
          Taffybar derivation to use.
        '';
      };

      extraPackages = mkOption {
        default = self: [];
        defaultText = "self: []";
        example = literalExample ''
          haskellPackages: [
            haskellPackages.aeson
          ]
        '';
        description = ''
          Extra packages available to ghc when rebuilding taffybar. The
          value must be a function which receives the attrset defined
          in <varname>haskellPackages</varname> as the solw argument.
        '';
      };

    };
  };

  config = mkIf cfg.enable {
    systemd.user.services.taffybar = {
      description = "Taffybar desktop bar.";
      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      after = [ "graphical-session-pre.target" ];
      serviceConfig = {
        ExecStart = "${cfg.package}/bin/taffybar";
      };
    };

    environment.systemPackages = [ cfg.package ];
  };

}

