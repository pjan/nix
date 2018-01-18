{ config, lib, pkgs, ... }:

let
  homedir = config.home.homeDirectory;
in with config; {

  home = {
    sessionVariables = {
      GNUPGHOME          = "${xdg.configHome}/gnupg";
    };
  };

  xdg.configFile."gnupg/gpg-agent.conf" = {
    text = ''
      enable-ssh-support
      default-cache-ttl 600
      max-cache-ttl 7200
      pinentry-program ${pkgs.pinentry_mac}/Applications/pinentry-mac.app/Contents/MacOS/pinentry-mac
      scdaemon-program ${xdg.configHome}/gnupg/scdaemon-wrapper
    '';
  };

  xdg.configFile."gnupg/scdaemon-wrapper" = {
    text = ''
      #!/bin/bash
      export DYLD_FRAMEWORK_PATH=/System/Library/Frameworks
      exec ${pkgs.gnupg}/libexec/scdaemon "$@"
    '';
    executable = true;
  };

  programs.bash = {
    bashrcExtra = lib.mkBefore ''
      export SSH_AUTH_SOCK=$(${pkgs.gnupg}/bin/gpgconf --list-dirs agent-ssh-socket)
    '';

    profileExtra = ''
      export GPG_TTY=$(${pkgs.coreutils}/bin/tty)
      if ! pgrep -x "gpg-agent" > /dev/null; then
          ${pkgs.gnupg}/bin/gpgconf --launch gpg-agent
      fi
    '';
  };

}
