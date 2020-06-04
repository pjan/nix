{ config, lib, pkgs, ...}: {

  system.defaults = {
    dock = {
      autohide = true;
      autohide-delay = "0.0";
      autohide-time-modifier = ".0";
      dashboard-in-overlay = true;
      enable-spring-load-actions-on-all-items = true;
      expose-animation-duration = "0.25";
      expose-group-by-app = false;
      launchanim = false;
      mineffect = "scale";
      minimize-to-application = true;
      mouse-over-hilite-stack = true;
      mru-spaces = false;
			orientation = "left";
      show-process-indicators = true;
      showhidden = true;
			show-recents = false;
      tilesize = 24;
    };

    finder = {
      CreateDesktop = false;
    };

		loginwindow = {
			ShutDownDisabledWhileLoggedIn = true;
			PowerOffDisabledWhileLoggedIn = true;
			RestartDisabledWhileLoggedIn = true;
		};

    NSGlobalDomain = {
      AppleFontSmoothing = 1;
      AppleKeyboardUIMode = 3;
      ApplePressAndHoldEnabled = false;
      AppleShowAllExtensions = true;
      AppleShowScrollBars = "Always";
      NSAutomaticCapitalizationEnabled = false;
      NSAutomaticDashSubstitutionEnabled = false;
      NSAutomaticPeriodSubstitutionEnabled = false;
      NSAutomaticQuoteSubstitutionEnabled = false;
      NSDisableAutomaticTermination = true;
      NSDocumentSaveNewDocumentsToCloud = false;
      NSNavPanelExpandedStateForSaveMode = true;
      NSNavPanelExpandedStateForSaveMode2 = true;
      NSTableViewDefaultSizeMode = 2;
      NSTextShowsControlCharacters = true;
      NSUseAnimatedFocusRing = false;
      NSScrollAnimationEnabled = true;
      NSWindowResizeTime = "0.001";
      InitialKeyRepeat = 20;
      KeyRepeat = 2;
      PMPrintingExpandedStateForPrint = true;
      PMPrintingExpandedStateForPrint2 = true;
      "com.apple.mouse.tapBehavior" = 1;
      "com.apple.trackpad.enableSecondaryClick" = true;
      "com.apple.trackpad.trackpadCornerClickBehavior" = 1;
      "com.apple.springing.enabled" = true;
      "com.apple.springing.delay" = "0.00";
      "com.apple.swipescrolldirection" = true;
    };
  };

}
