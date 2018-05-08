{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.programs.shells.bash;

  historyFilePath = concatStringsSep "/" (init (splitString "/" cfg.historyFile));

  historySettings =
    concatStringsSep "\n" (mapAttrsToList (n: v: "${n}=${v}") (
      {
        HISTFILE = "\"${cfg.historyFile}\"";
        HISTFILESIZE = toString cfg.historyFileSize;
        HISTSIZE = toString cfg.historyMemorySize;
      }
      // optionalAttrs (cfg.historyControl != []) {
        HISTCONTROL = concatStringsSep ":" cfg.historyControl;
      }
      // optionalAttrs (cfg.historyIgnore != []) {
        HISTIGNORE = concatStringsSep ":" cfg.historyIgnore;
      }
    ));

    createHistoryFile = ''
      if [ ! -f ${cfg.historyFile} ]; then
        mkdir -p ${historyFilePath}
        touch ${cfg.historyFile}
      fi
    '';

  shopts =
    concatStringsSep "\n" (
      map (v: "shopt -s ${v}") cfg.shellOptions
    );

  dirclr = optionalString (cfg.dircolors != null) ''
    eval `${pkgs.coreutils}/bin/dircolors -b /etc/dircolors`
  '';

in {

  options = {

    programs.shells.bash = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Configure Bourne Again SHell
        '';
      };

      enableCompletion = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Enable Bash completion for all interactive bash shells.
        '';
      };

      historyFile = mkOption {
        type = types.str;
        default = "$HOME/.bash_history";
        example = "$HOME/.bash_history";
        description = ''
          Location of the bash history file.
        '';
      };

      historyMemorySize = mkOption {
        type = types.int;
        default = 10000;
        example = 10000;
        description = ''
          Number of history lines to keep in memory.
        '';
      };

      historyFileSize = mkOption {
        type = types.int;
        default = 100000;
        example = 100000;
        description = ''
          Number of history lines to keep on file.
        '';
      };

      historyControl = mkOption {
        type = types.listOf (types.enum [
          "erasedups"
          "ignoredups"
          "ignorespace"
        ]);
        default = [];
        example = [ "erasedups" ];
        description = ''
          Controlling how commands are saved on the history list.
        '';
      };

      historyIgnore = mkOption {
        type = types.listOf types.str;
        default = [];
        example = [ "ls" "cd" "exit" ];
        description = ''
          List of commands that should not be saved to the history list.
        '';
      };

      shellOptions = mkOption {
        type = types.listOf types.str;
        default = [
          # Append to history file rather than replacing it.
          "histappend"

          # Extended globbing.
          "extglob"
          "globstar"

          # @arn if closing shell with running jobs
          "checkjobs"
        ];
        example = [ "histappend" "extglob" "globstar" "checkjobs" ];
        description = ''
          List of shell options to set.
        '';
      };

      shellAliases = mkOption {
        type = types.attrs;
        default = config.environment.shellAliases;
        example = { ll = "ls -l"; ".." = "cd .."; };
        description = ''
          Set of aliases for bash shell. See <option>environment.shellAliases</option>
          for an option format description.
        '';
      };

      promptInit = mkOption {
        type = types.lines;
        default = ''
          # Provide a nice prompt if the terminal supports it.
          if [ "$TERM" != "dumb" -o -n "$INSIDE_EMACS" ]; then
            PROMPT_COLOR="1;31m"
            let $UID && PROMPT_COLOR="1;32m"
            PS1="\n\[\033[$PROMPT_COLOR\][\u@\h:\w]\\$\[\033[0m\] "
            if test "$TERM" = "xterm"; then
              PS1="\[\033]2;\h:\u:\w\007\]$PS1"
            fi
          fi
        '';
        description = ''
          Shell script code used to initialise the bash prompt.
        '';
      };

      dircolors = mkOption {
        type = types.nullOr types.lines;
        default = null;
        description = ''
          Dircolors configuration.
        '';
      };
    };

  };

  config = mkIf cfg.enable (mkMerge [
    (mkIf (cfg.dircolors != null) {
      environment.etc.dircolors.text = ''
        ${cfg.dircolors}
      '';
    })

    {
      programs.bash.interactiveShellInit = ''
        ${createHistoryFile}

        ${historySettings}

        ${shopts}

        ${dirclr}
      '';

      programs.bash.enableCompletion = cfg.enableCompletion;

      programs.bash.shellAliases = cfg.shellAliases;

      programs.bash.promptInit = cfg.promptInit;

    }
  ]);

}
