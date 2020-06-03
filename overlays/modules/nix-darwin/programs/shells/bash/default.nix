{ config, lib, pkgs, ... }:

with lib;

let

  cfge = config.environment;

  cfg = config.programs.shells.bash;

  bashCompletion = optionalString cfg.enableCompletion ''
    # Check whether we're running a version of Bash that has support for
    # programmable completion. If we do, enable all modules installed in
    # the system and user profile in obsolete /etc/bash_completion.d/
    # directories. Bash loads completions in all
    # $XDG_DATA_DIRS/bash-completion/completions/
    # on demand, so they do not need to be sourced here.
    if [ "$TERM" != "dumb" ]; then
      source "${pkgs.bash-completion}/etc/profile.d/bash_completion.sh"

      nullglobStatus=$(shopt -p nullglob)
      shopt -s nullglob
      for p in $NIX_PROFILES; do
        for m in "$p/etc/bash_completion.d/"*; do
          . $m
        done
      done
      eval "$nullglobStatus"
      unset nullglobStatus p m
    fi
  '';

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

  bashAliases = concatStringsSep "\n" (
    mapAttrsFlatten (k: v: "alias ${k}=${escapeShellArg v}")
      (filterAttrs (k: v: v != null) cfg.shellAliases)
  );

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

      shellInitExtra = mkOption {
        type = types.lines;
        default = "";
        description = ''
          Additional interactive shell init content.
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
			programs.bash.enable = false;

      environment.systemPackages =
        [ # Include bash package
          pkgs.bashInteractive
        ] ++ optional cfg.enableCompletion pkgs.bash-completion;

      environment.pathsToLink =
        [ "/etc/bash_completion.d"
          "/share/bash-completion/completions"
        ];

      environment.loginShell = mkDefault "bash -l";
      environment.variables.SHELL = mkDefault "${pkgs.bashInteractive}/bin/bash";

      environment.etc."bashrc".text = ''
        # /etc/bashrc: DO NOT EDIT -- this file has been generated automatically.
        # This file is read for interactive shells.

        [ -r "/etc/bashrc_$TERM_PROGRAM" ] && . "/etc/bashrc_$TERM_PROGRAM"

        # Only execute this file once per shell.
        if [ -n "$__ETC_BASHRC_SOURCED" -o -n "$NOSYSBASHRC" ]; then return; fi
        __ETC_BASHRC_SOURCED=1

        # Don't execute this file when running in a pure nix-shell.
        # if test -n "$IN_NIX_SHELL"; then return; fi

        if [ -z "$__NIX_DARWIN_SET_ENVIRONMENT_DONE" ]; then
          . ${config.system.build.setEnvironment}
        fi

        # Return early if not running interactively, but after basic nix setup.
        [[ $- != *i* ]] && return

        # Make bash check its window size after a process completes
        shopt -s checkwinsize

        ${cfg.promptInit}
        ${bashCompletion}
        ${createHistoryFile}
        ${historySettings}
        ${shopts}
        ${dirclr}
        ${bashAliases}
        ${cfg.shellInitExtra}

        # Read system-wide modifications.
        if test -f /etc/bash.local; then
          source /etc/bash.local
        fi
      '';

    }
  ]);

}