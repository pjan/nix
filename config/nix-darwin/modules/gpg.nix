{ config, lib, pkgs, ... }:

let

in {

  environment.systemPackages = [ pkgs.gnupg ];

  programs.shells.bash.shellInitExtra = ''
    export GPG_TTY=$(tty)
    if ! pgrep -x "gpg-agent" > /dev/null; then
        ${pkgs.gnupg}/bin/gpgconf --launch gpg-agent
    fi
  '';

}
