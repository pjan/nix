{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.programs.neovim;

in {

  options = {

    programs.neovim = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          When enabled, installs NeoVim and configures NeoVim to be the default
          editor using the EDITOR environment variable.
        '';
      };

      plugins = mkOption {
        type = types.listOf types.attrs;
        default = [];
        example = [ { names = [ "surround" "vim-nix" ]; } ];
        description = ''
          VAM plugin dictionaries to use for NeoVim.
        '';
      };

      config = mkOption {
        type = types.lines;
        default = "";
        description = ''
          NeoVim configuration
        '';
      };

    };

  };

  config = mkIf cfg.enable {

    environment.variables.EDITOR = "${neovim}/bin/nvim";

  };

}
