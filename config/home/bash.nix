{ config, lib, pkgs, ... }:

let
  homedir = config.home.homeDirectory;
in with config; {

  home.sessionVariables = {
    INPUTRC        = "${xdg.configHome}/bash/inputrc";
    "LS_COLORS"    = "no=00:fi=00:di=01;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.ogg=01;35:*.mp3=01;35:*.wav=01;35:";
    PROMPT_DIRTRIM = "4";
  };

  programs.bash = {
    enable = true;

    historySize     = 32768;
    historyFileSize = 32768;
    historyFile     = "${xdg.dataHome}/bash/history";
    historyControl  = [
      "erasedups"
      "ignoredups"
      "ignorespace"
    ];
    historyIgnore = [
      "ls"
      "cd"
      "\"cd -\""
      "pwd"
      "exit"
      "date"
      "\"* --help\""
    ];

    shellOptions    = [
      # Append to the Bash history file, rather than overwriting it
      "histappend"

      "autocd"

      # check the window size after each command and, if
      # necessary, update the values of LINES and COLUMNS.
      "checkwinsize"

      # Case-insensitive globbing (used in pathname expansion)
      "nocaseglob"

      # Extended globbing.
      # "extglob"
      "globstar"

      # Autocorrect typos in path names when using `cd`
      "cdspell"

      # Warn if closing shell with running jobs.
      "checkjobs"
    ];

    shellAliases = {
      # Folder navigation
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";
      "....." = "cd ../../../..i";

      # Applications
      vi  = "vim";
      g   = "${pkgs.gitAndTools.hub}/bin/hub";
      git = "${pkgs.gitAndTools.hub}/bin/hub";
      mux = "${pkgs.tmuxinator}/bin/tmuxinator";

      # lsstuff
      ls = "${pkgs.coreutils}/bin/ls --color";
      ll = "ls -ahlF";
      la = "ls -A";
      lf = "ls -lF";

      # Securily remove
      "rm!" = "${pkgs.srm}/bin/srm -vfr";

      # make sure aliases can be sudo'ed
      sudo = "sudo ";

      # Get week number
      week = "date +%V";

      # Gzip-enabled curl
      gurl = "curl --compressed";

      # Stopwatch
      timer = "echo \"Timer started. Stop with Ctrl-D.\" && date && time cat && date";

      # Recursively deleate `.DS_Store` files
      cleanup = "find . -type f -name \"*.DS_Store\" -ls -delete";

      # Flush Directory Service cache
      flushdns = "dscacheutil -flushcache && killall -HUP mDNSResponder";

      # Clean up LaunchServices to remove duplicates in the “Open With” menu
      lscleanup = "/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user && killall Finder";

      # IP addresses
      ip = "dig +short myip.opendns.com @resolver1.opendns.com";
      localip = "ipconfig getifaddr en0";
      ips = "ifconfig -a | grep -o \"inet7\? \(\([0-9]\+\.[0-9]\+\.[0-9]\+\.[0-9]\+\)\|[a-fA-F0-9:]\+\)\" | sed -e \"s/inet6* //\"";

      # Enhanced whois lookup
      whois = "whois -h whois-servers.net";

      # Empty the Trash on all mounted volumes and the main HDD
      # Also, clear Apple’s System Logs to improve shell startup speed
      emptytrash = "sudo rm -rfv /Volumes/*/.Trashes; sudo rm -rfv ~/.Trash; sudo rm -rfv /private/var/log/asl/*.asl";

      # Show/hide hidden files in Finder
      show = "defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder";
      hide = "defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder";

      # Hide/show all desktop icons (useful when presenting)
      hidedesktop = "defaults write com.apple.finder CreateDesktop -bool false && killall Finder";
      showdesktop = "defaults write com.apple.finder CreateDesktop -bool true && killall Finder";

      # URL-encode strings
      urlencode = "python -c \"import sys, urllib as ul; print ul.quote_plus(sys.argv[1]);\"";

      # Command line User Agent functions
      GET = "lwp-request -m GET";
      HEAD = "lwp-request -m HEAD";
      POST = "lwp-request -m POST";
      PUT = "lwp-request -m PUT";
      DELETE = "lwp-request -m DELETE";
      TRACE = "lwp-request -m TRACE";
      OPTIONS = "lwp-request -m OPTIONS";

      # Intuitive map function
      # For example, to list all directories that contain a certain file:
      # find . -name .gitattributes | map dirname
      map = "xargs -n1";

      # PlistBuddy alias
      plistbuddy = "/usr/libexec/PlistBuddy";

      # Disable/Enable spotlight
      spoton = "sudo mdutil -a -i on";
      spotoff = "sudo mdutil -a -i off";

      # Turn the lights off
      afk = "/System/Library/CoreServices/Menu\\ Extras/User.menu/Contents/Resources/CGSession -suspend";

      # Reload the shell (i.e. invoke as a login shell)
      reload = "exec $SHELL -l";
    };

    bashrcExtra = lib.mkBefore ''
      if [[ -x "$(which docker-machine)" ]]; then
          if docker-machine status default > /dev/null 2>&1; then
              eval $(docker-machine env default) > /dev/null 2>&1
          fi
      fi

      # create history file if it doesn't exist
      if [[ ! -f ${xdg.dataHome}/bash/history ]]; then
          mkdir -p ${xdg.dataHome}/bash
          touch ${xdg.dataHome}/bash/history
      fi

      # completion
      if [[ $PS1 && -f ${xdg.configHome}/bash/completion ]]; then
        . ${xdg.configHome}/bash/completion
      fi

      if [[ $PS1 && -f ${xdg.configHome}/bash/dircolors ]]; then
        eval `${pkgs.coreutils}/bin/dircolors -b ${xdg.configHome}/bash/dircolors`
      fi

      # prompt
      if [[ $PS1 && -f ${xdg.configHome}/bash/prompt ]]; then
        . ${xdg.configHome}/bash/prompt
      fi
    '';
  };

  home.file.".bash_logout".text = ''
    shell_session_update
  '';

  xdg.configFile = {
    "bash/completion".source = ../shared/config/bash/completion;
    "bash/dircolors".source = ../shared/config/bash/dircolors;
    "bash/inputrc".source = ../shared/config/bash/inputrc;
    "bash/prompt".source = ../shared/config/bash/prompt;
  };

}
