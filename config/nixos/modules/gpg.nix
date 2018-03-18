{ config, lib, pkgs, ... }:

{

  #programs.gnupg.agent = {
  #  enable = true;
  #  enableSSHSupport = true;
  #};

  programs.ssh.startAgent = false;

  # daemon that exposes a generic API that allows programs to communicate with smartcards
  services.pcscd.enable = true;

  environment.systemPackages = with pkgs; [
    gnupg
    yubikey-personalization
  ];

  environment.extraInit = ''
    export GPG_TTY=$(tty)

    ${pkgs.gnupg}/bin/gpg-connect-agent --quiet updatestartuptty /bye > /dev/null
    
    if [ -z "$SSH_AUTH_SOCK" ]; then
      export SSH_AUTH_SOCK=$(${pkgs.gnupg}/bin/gpgconf --list-dirs agent-ssh-socket)
    fi
  '';

  services.udev.packages = with pkgs; [
    yubikey-personalization
  ];

}
