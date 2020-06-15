{ config, lib, pkgs, ... }:

let

  homeDirectory = config.home.homeDirectory;

in {

  xdg = {
    configHome = "${homeDirectory}/.config";
    dataHome = "${homeDirectory}/.local/share";
    cacheHome = "${homeDirectory}/.cache";
  };

  system.stateVersion = 2;
  services.activate-system.enable = true;
  services.nix-daemon.enable = false;

  imports = import (<nixpkgs-overlays> + "/modules/nix-darwin") ++ [
    ./modules/aria.nix
    ./modules/bash.nix
    ./modules/defaults.nix
    ./modules/gpg.nix
    ./modules/networking.nix
    ./modules/neovim.nix
    ./modules/nix.nix
    ./modules/packages.nix
    ./modules/privacy.nix
    ./modules/tmux.nix
    ../shared/modules/nixpkgs.nix
  ];

  programs.home-manager.enable = true;

  environment.etc."DefaultKeyBinding.dict".text = ''
    {
      "~f"    = "moveWordForward:";
      "~b"    = "moveWordBackward:";
      "~d"    = "deleteWordForward:";
      "~^h"   = "deleteWordBackward:";
      "~\010" = "deleteWordBackward:";    /* Option-backspace */
      "~\177" = "deleteWordBackward:";    /* Option-delete */
      "~v"    = "pageUp:";
      "^v"    = "pageDown:";
      "~<"    = "moveToBeginningOfDocument:";
      "~>"    = "moveToEndOfDocument:";
      "^/"    = "undo:";
      "~/"    = "complete:";
      "^g"    = "_cancelKey:";
      "^a"    = "moveToBeginningOfLine:";
      "^e"    = "moveToEndOfLine:";
      "~c"	  = "capitalizeWord:"; /* M-c */
      "~u"	  = "uppercaseWord:";	 /* M-u */
      "~l"	  = "lowercaseWord:";	 /* M-l */
      "^t"	  = "transpose:";      /* C-t */
      "~t"	  = "transposeWords:"; /* M-t */
    }
  '';

  # fix for catalina coming with zshell, but keeping bash as default shell
  programs.zsh.enable = true;
  environment.loginShell = "bash -l";
  environment.variables.SHELL = "${pkgs.bashInteractive}/bin/bash";

}
