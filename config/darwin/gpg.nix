{ config, pkgs, ...}:

let
  home = builtins.getEnv "HOME";
in {

  environment.etc."per-user/pjan/scdaemon-wrapper".text = ''
    #!/bin/bash
    export DYLD_FRAMEWORK_PATH=/System/Library/Frameworks
    exec ${pkgs.gnupg}/libexec/scdaemon "$@"
  '';

  environment.etc."per-user/pjan/gpg-agent.conf".text = ''
    enable-ssh-support
    default-cache-ttl 600
    max-cache-ttl 7200
    pinentry-program ${pkgs.pinentry_mac}/Applications/pinentry-mac.app/Contents/MacOS/pinentry-mac
    scdaemon-program ${home}/.gnupg/scdaemon-wrapper
  '';

  system.activationScripts.extraPostActivation.text = ''
    cp -p /etc/per-user/pjan/scdaemon-wrapper ~/.gnupg
    chmod +x ~/.gnupg/scdaemon-wrapper

    cp -p /etc/per-user/pjan/gpg-agent.conf ~/.gnupg
    ${pkgs.gnupg}/bin/gpgconf --launch gpg-agent
  '';
}
