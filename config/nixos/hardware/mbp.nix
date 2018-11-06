{ config, lib, pkgs, ... }:

let

in {

  boot = {
    loader = {
      # Use the systemd EFI bootloader
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    kernelModules = [
      "msr"
      "coretemp"
      "applesmc"
    ];
    cleanTmpDir = true;
  };

  hardware = {
    enableRedistributableFirmware = true;
    cpu.intel.updateMicrocode = true;
    bluetooth.enable = true;
    facetimehd.enable = true;

    opengl = {
      enable = true;
      driSupport32Bit = true;
      extraPackages = [ pkgs.vaapiIntel ];
    };

    pulseaudio = {
      enable = true;
      package = pkgs.pulseaudioFull;
      systemWide = false;
      support32Bit = true;
      daemon.config.flat-volumes = "no";
    };
  };

  powerManagement.enable = true;

  programs.light.enable = true;

  sound = {
    enable = true;

    mediaKeys.enable = true;
  };

  services.actkbd = {
    enable = true;
    bindings = [
      { keys = [ 224 ]; events = [ "key" "rep" ]; command = "${pkgs.light}/bin/light -U 4"; }
      { keys = [ 225 ]; events = [ "key" "rep" ]; command = "${pkgs.light}/bin/light -A 4"; }
      { keys = [ 229 ]; events = [ "key" "rep" ]; command = "${pkgs.kbdlight}/bin/kbdlight down"; }
      { keys = [ 230 ]; events = [ "key" "rep" ]; command = "${pkgs.kbdlight}/bin/kbdlight up"; }
    ];
  };

  services.avahi.enable = true;

  services.logind.extraConfig = ''
    HandlePowerKey = suspend
  '';

  services.mbpfan.enable = true;

  services.printing = {
    enable = true;
    drivers = [
      pkgs.gutenprint
    ];
  };

  services.upower.enable = true;

}

