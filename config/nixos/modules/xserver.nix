{ config, lib, pkgs, ... }:

let
  background = "#002b36"; # pkgs.copyPathToStore ../../shared/resources/bg2.jpg;
in {

  services.xserver = {
    enable = true;

    exportConfiguration = true;

    autoRepeatDelay = 250;
    autoRepeatInterval = 25;

    layout = "us";

    xkbOptions = "caps:ctrl_modifier, terminate:ctrl_alt_bksp"; #, altwin:ctrl_win";

    desktopManager = {
      default = "none";
      # wallpaper = "fill";
      xterm.enable = false;
    };

    displayManager = {
      lightdm = {
        enable = true;
        background = background;
      };
      sessionCommands = ''
        ${pkgs.xlibs.xsetroot}/bin/xsetroot -cursor_name left_ptr
        ${pkgs.xlibs.xrdb}/bin/xrdb -merge ~/.Xresources
        ${pkgs.xcape}/bin/xcape -e 'Caps_Lock=Escape'
      '';
    };

    windowManager = {
      default = "xmonad";
      xmonad = {
        enable = true;
        enableContribAndExtras = true;
        extraPackages = haskellPackages: [
          haskellPackages.taffybar
        ];
      };
    };

    resolutions = [
      { x = 1920; y = 1200; }
      { x = 2880; y = 1800; }
      { x = 1680; y = 1050; }
      { x = 1280; y = 800;  }
    ];

    multitouch = {
      enable = true;
      invertScroll = true;
      ignorePalm = true;
    };

    synaptics = {
      enable = true;
      vertEdgeScroll = false;
      tapButtons = false;
      twoFingerScroll = true;
      horizontalScroll = true;
      buttonsMap = [ 3 3 3 ];
      additionalOptions = ''
        Option "Sensitivity" "0.50"
        Option "FingerHigh" "12"
        Option "FingerLow" "12"
        Option "IgnoreThumb" "true"
        Option "ThumbRatio" "70"
        Option "ThumbSize" "20"
        Option "IgnorePalm" "true"
        Option "ButtonMoveEmulate" "false"
        Option "ButtonIntegrated" "true"
        Option "ButtonEnable" "true"
        Option "ButtonZonesEnable" "false"
        Option "ClickTime" "25"
        Option "EdgeBottomSize" "30"
        Option "SwipeLeftButton" "8"
        Option "SwipeRightButton" "9"
        Option "SwipeUpButton" "0"
        Option "SwipeDownButton" "0"
        Option "SwipeDistance" "700"
        #Option "ScrollCoastDuration" "500"
        #Option "ScrollCoastEnableSpeed" "0.1"
        Option "Hold1Move1StationaryMaxMove" "1000"
        Option "ScrollDistance" "200"
        Option "ScrollClickTime" "12"
        Option "ScrollSensitivity" "0"
        Option "TapButton1" "0"
        Option "TapButton2" "0"
        Option "TapButton3" "0"
        Option "TapButton4" "0"
        Option "EmulateThirdButton" "true"
        Option "EmulateThirdButtonTimeout" "1000"
        Option "EmulateThirdButtonMoveTreshold" "30"
      '';
    };
  };

  services.autorandr.enable = true;

  services.taffybar = {
    enable = true;
    extraPackages = self: [];
  };

  services.unclutter-xfixes.enable = true;

  services.wallpaper = {
    enable = true;
    directory = "/data/images/wallpapers";
    interval = 3600;
  };

}
