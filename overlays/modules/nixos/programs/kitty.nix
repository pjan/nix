{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.programs.kitty;

  package =
    if (cfg.config != null)
    then pkgs.writeShellScriptBin "kitty" ''
      ${pkgs.kitty}/bin/kitty --config /etc/kitty/kitty.conf "$@"
    ''
    # pkgs.kitty.overrideDerivation (oldAttrs: {
    #   installPhase = ''
    #     runHook preInstall
    #     mkdir -p $out
    #     cp -r linux-package/{bin,share,lib} $out
    #     wrapProgram "$out/bin/kitty" --add-flags "--config /etc/kitty/kitty.conf" --prefix PATH : "$out/bin:${pkgs.stdenv.lib.makeBinPath [ pkgs.imagemagick pkgs.xsel ]}"
    #     runHook postInstall
    #   '';
    # })
    else pkgs.kitty;

in {

  options = {

    programs.kitty = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Kitty terminal.
        '';
      };

      config = mkOption {
        type = types.nullOr types.lines;
        default = null;
        description = ''
          Kitty configuration.
        '';
      };

    };

  };

  config = mkIf cfg.enable (mkMerge [
    (mkIf (cfg.config != null) {
      environment.etc."kitty/kitty.conf".text = ''
        ${cfg.config}
      '';
    })

    {
      environment.systemPackages = [ package ];
    }
  ]);

}

