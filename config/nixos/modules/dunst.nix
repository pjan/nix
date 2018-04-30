{ config, lib, pkgs, ... }:

let

in {

  services.dunst = {
    enable = true;

    config = ''
      [global]
          font                 = FiraCode-Retina 10
          markup               = yes
          plain_text           = no
          format               = "<b>%s</b>\n\n%b"
          transparency         = 0
          ignore_newline       = no
          show_indicators      = yes
          separator_color      = frame

          sort                 = yes
          alignment            = left
          bounce_freq          = 0
          word_wrap            = yes

          indicate_hidden      = yes
          show_age_threshold   = 60
          idle_threshold       = 120

          geometry             = "300x10-0+30"
          shrink               = no
          line_height          = 0
          notification_height  = 100
          separator_height     = 2
          padding              = 10
          horizontal_padding   = 8

          monitor              = 0
          follow               = mouse

          sticky_history       = yes
          history_length       = 20

          icon_position        = left

          startup_notification = false
          dmenu                = /usr/bin/dmenu -p dunst:
          browser              = ${pkgs.chromium}/bin/chromium

          frame_width          = 1
          frame_color          = "#93a1a1"

      [shortcuts]
          close     = ctrl+space
          close_all = ctrl+shift+space
          history   = ctrl+grave
          context   = ctrl+shift+period

      [urgency_low]
          background = "#586e75"
          foreground = "#eee8d5"
          timeout = 10

      [urgency_normal]
          background = "#073642"
          foreground = "#eee8d5"
          timeout = 15

      [urgency_critical]
          background = "#dc322f"
          foreground = "#eee8d5"
          timeout = 0
    '';
  };

}

