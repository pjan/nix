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
    # shadowOpacity = "0.5";
    menuOpacity = "0.8";
    extraOptions = ''
      unredir-if-possible = true;
      no-dock-shadow = true;
      clear-shadow = true;
      shadow-radius = 10;
      detect-rounded-corners = true;
      shadow-ignore-shaped = true;
      wintypes:
      {
        notify = { fade = true; shadow = true; opacity = 0.9; focus = true; };
        tooltip = { fade = true; shadow = true; opacity = 0.9; focus = true; };
      };
    '';
  };

}
