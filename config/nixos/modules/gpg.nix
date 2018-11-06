{ config, lib, pkgs, ... }:

{

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  programs.ssh.startAgent = false;

  # daemon that exposes a generic API that allows programs to communicate with smartcards
  services.pcscd.enable = true;

  environment.systemPackages = with pkgs; [
    gnupg
    yubikey-personalization
  ];

  services.udev = {
    packages = with pkgs; [
      yubikey-personalization
    ];

    # extraRules = ''
    #   # this udev file should be used with udev older than 188
    #   ACTION!="add|change", GOTO="u2f_end"

    #   # Yubico YubiKey
    #   KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="1050", ATTRS{idProduct}=="0113|0114|0115|0116|0120|0200|0402|0403|0406|0407|0410", GROUP="plugdev", MODE="0660"

    #   # Happlink (formerly Plug-Up) Security KEY
    #   KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="2581", ATTRS{idProduct}=="f1d0", GROUP="plugdev", MODE="0660"

    #   #  Neowave Keydo and Keydo AES
    #   KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="1e0d", ATTRS{idProduct}=="f1d0|f1ae", GROUP="plugdev", MODE="0660"

    #   # HyperSecu HyperFIDO
    #   KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="096e|2ccf", ATTRS{idProduct}=="0880", GROUP="plugdev", MODE="0660"

    #   # Feitian ePass FIDO
    #   KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="096e", ATTRS{idProduct}=="0850|0852|0853|0854|0856|0858|085a|085b", GROUP="plugdev", MODE="0660"

    #   # JaCarta U2F
    #   KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="24dc", ATTRS{idProduct}=="0101", GROUP="plugdev", MODE="0660"

    #   # U2F Zero
    #   KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="10c4", ATTRS{idProduct}=="8acf", GROUP="plugdev", MODE="0660"

    #   # VASCO SeccureClick
    #   KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="1a44", ATTRS{idProduct}=="00bb", GROUP="plugdev", MODE="0660"

    #   # Bluink Key
    #   KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="2abe", ATTRS{idProduct}=="1002", GROUP="plugdev", MODE="0660"

    #   # Thetis Key
    #   KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="1ea8", ATTRS{idProduct}=="f025", GROUP="plugdev", MODE="0660"

    #   # Nitrokey FIDO U2F
    #   KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="20a0", ATTRS{idProduct}=="4287", GROUP="plugdev", MODE="0660"

    #   # Google Titan U2F
    #   KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="18d1", ATTRS{idProduct}=="5026", GROUP="plugdev", MODE="0660"

    #   LABEL="u2f_end"
    # '';

  };

}
