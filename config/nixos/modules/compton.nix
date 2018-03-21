{ config, lib, pkgs, ... }:

let

in {

  services.compton = {
    enable = true;
    fade = true;
    fadeSteps = [ "0.09" "0.09" ];
    fadeExclude = [
      "g:e:SMPlayer"
    ];
    shadow = true;
    shadowOffsets = [ (-10) (-10) ];
    shadowOpacity = "0.5";
    shadowExclude = [
      "_GTK_FRAME_EXTENTS@:c"
    ];
    menuOpacity = "0.9";
    extraOptions = ''
    '';
  };

}
