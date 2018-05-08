{ config, lib, pkgs, ... }:

let

  git = "${pkgs.git}/bin/git";

in {

  programs.shells.bash = {
    enable = true;

    enableCompletion = true;

    historyFile = "$HOME/.local/share/bash/history";
    historyMemorySize = 10000;
    historyFileSize = 100000;
    historyControl = [
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

    shellOptions = [
      # Append to the Bash history file, rather than overwriting it
      "histappend"

      "autocd"

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
      "....." = "cd ../../../..";

      # Applications
      vi = "nvim";

      # lsstuff
      ls = "${pkgs.coreutils}/bin/ls --color";
      ll = "ls -ahlF";
      la = "ls -A";
      lf = "ls -lF";

      # Secure remove
      "rm!" = "${pkgs.srm}/bin/srm -vfr";
    };

    promptInit = ''
      # -----------------------------------------------------------------------------
      # returns a string with the powerline symbol for a section end
      # arg: $1 is foreground color of the next section
      # arg: $2 is background color of the next section
      function section_end {
        if [ "$__last_color" == "$2" ]; then
          # Section colors are the same, use a foreground separator
          local end_char="''${symbols[soft_separator]}"
          local fg=$1
        else
          # section colors are different, use a background separator
          local end_char="''${symbols[hard_separator]}"
          local fg=$__last_color
        fi
        if [ -n "$__last_color" ]; then
          echo "''${colors[$fg]}''${colors[BG_$2]}$end_char"
        fi
      }

      # -----------------------------------------------------------------------------
      # returns a string with background and foreground colours set
      # arg: $1 foreground color
      # arg: $2 background color
      # arg: $3 content
      function section_content {
        echo "''${colors[$1]}''${colors[BG_$2]}$3"
      }

      # -----------------------------------------------------------------------------
      # append to prompt: root user notification
      # arg: $1 background color
      # arg: $2 foreground color
      function root_module {
        if [[ ''${EUID} = 0 ]]; then
          local bg=$1
          local fg=$2
          local content="!"
          PS1+=$(section_end $fg $bg)
          PS1+=$(section_content $fg $bg " $content ")
          __last_color=$bg
        fi
      }

      #------------------------------------------------------------------------------
      # append to prompt: user@host or user or root@host
      # arg: $1 background color
      # arg: $2 background color when connected over ssh
      # arg: $3 foreground color
      function user_host_module {
        local bg=$1
        local fg=$3
        local content="\u@\h"
        if [[ "''${SSH_TTY}" || "''${SSH_CLIENT}" ]]; then
          bg=$2
        fi

        PS1+=$(section_end $fg $bg)
        PS1+=$(section_content $fg $bg " $content ")
        __last_color=$bg
      }

      # -----------------------------------------------------------------------------
      # append to prompt: current directory
      # arg: $1 background color
      # arg; $2 foreground color
      # optional arg: $3 - 0 — fullpath, 1 — current dir, [x] — trim to x number of
      # directories
      function path_module {
        local bg=$1
        local fg=$2
        local content="\w"
        if [ $3 -eq 1 ]; then
          local content="\W"
        elif [ $3 -gt 1 ]; then
          PROMPT_DIRTRIM=$3
        fi
        PS1+=$(section_end $fg $bg)
        PS1+=$(section_content $fg $bg " $content ")
        __last_color=$bg
      }

      # -----------------------------------------------------------------------------
      # append to prompt: the number of background jobs running
      # arg: $1 foreground color
      # arg; $2 background color
      function jobs_module {
        local bg_color=$1
        local fg_color=$2
        local number_jobs=$(jobs -p | wc -l)
        if [ ! "$number_jobs" -eq 0 ]; then
          PS1+=$(section_end $fg_color $bg_color)
          PS1+=$(section_content $fg_color $bg_color " ''${symbols[enter]} $number_jobs ")
          __last_color=$bg_color
        fi
      }

      # -----------------------------------------------------------------------------
      # append to prompt: indicator if the current directory is ready-only
      # arg: $1 foreground color
      # arg; $2 background color
      function read_only_module {
        local bg_color=$1
        local fg_color=$2
        if [ ! -w "$PWD" ]; then
          PS1+=$(section_end $fg_color $bg_color)
          PS1+=$(section_content $fg_color $bg_color " ''${symbols[lock]} ")
          __last_color=$bg_color
        fi
      }

      # -----------------------------------------------------------------------------
      # append to prompt: git branch with indictors
      # arg: $1 foreground color
      # arg; $2 background color
      # arg: $3 background color used if the working directory is dirty
      function git_module {
        local git_branch=$(${git} rev-parse --abbrev-ref HEAD 2> /dev/null)

        if [ -n "$git_branch" ]; then
          # Ensure the index is up to date
          ${git} update-index --really-refresh -q &>/dev/null;

          local content="''${symbols[git]} $git_branch$git"

          local bg=$1
          local fg=$2
          if [ -n "$3" -a -n "$(git status --porcelain)" ]; then
            bg=$3
          fi

          local status=""
          local number_modified=$(${git} diff --name-only --diff-filter=M 2> /dev/null | wc -l )
          if [ ! "$number_modified" -eq "0" ]; then
            status+="''${symbols[plus]}" # $number_modified"
          fi

          local number_staged=$(${git} diff --staged --name-only --diff-filter=AM 2> /dev/null | wc -l)
          if [ ! "$number_staged" -eq "0" ]; then
            status+="''${symbols[tick]}" # $number_staged"
          fi

          local number_conflicts=$(${git} diff --name-only --diff-filter=U 2> /dev/null | wc -l)
          if [ ! "$number_conflicts" -eq "0" ]; then
            status+="''${symbols[cross]}" # $number_conflicts"
          fi

          local number_untracked=$(${git} ls-files --other --exclude-standard | wc -l)
          if [ ! "$number_untracked" -eq "0" ]; then
            status+="''${symbols[untracked]}" # $number_untracked"
          fi

          content+=" $status"

          local number_stash=$(${git} stash list 2>/dev/null | wc -l)
          if [ ! "$number_stash" -eq 0 ]; then
            content+=" ''${symbols[soft_separator]} ''${symbols[stash]}$number_stash"
          fi

          local number_behind_ahead=$(${git} rev-list --count --left-right '@{upstream}...HEAD' 2>/dev/null)
          local number_ahead="''${number_behind_ahead#*	}"
          local number_behind="''${number_behind_ahead%	*}"
          if [ ! "0$number_ahead" -eq 0 -o ! "0$number_behind" -eq 0 ]; then
            if [ ! "$number_ahead" -eq 0 ]; then
              content+=" ''${symbols[soft_separator]} ''${symbols[ahead]}$number_ahead"
            fi
            if [ ! "$number_behind" -eq 0 ]; then
              content+=" ''${symbols[soft_separator]} ''${symbols[behind]}$number_behind"
            fi
          fi

          PS1+=$(section_end $fg $bg)
          PS1+=$(section_content $fg $bg " $content ")
          __last_color=$bg
        fi
      }

      # -----------------------------------------------------------------------------
      # append to prompt: optionally append return code for previous command
      # arg: $1 background color
      # arg; $2 foreground color
      function return_code_module {
        if [ ! "$__return_code" -eq 0 ] && [ ! "$__return_code" -eq 130 ]; then
          local bg=$1
          local fg=$2
          local content=" ''${symbols[flag]} $__return_code "
          PS1+=$(section_end $fg $bg)
          PS1+=$(section_content $fg $bg "$content")
          __last_color=$bg
        fi
      }

      # -----------------------------------------------------------------------------
      # append to prompt: a nice prompt symbol
      # arg: $1 background color
      # arg: $2 foreground color
      function prompt_module {
        local bg=$1
        local fg=$2
        local content=" ''${symbols[prompt]}"
        PS1+=$(section_end $fg $bg)
        PS1+=$(section_content $fg $bg "$content")
        __last_color=$bg
      }

      # -----------------------------------------------------------------------------
      # append to prompt: is nix shell
      # arg: $1 background color
      # arg: $2 foreground color
      function nix_shell_module {
        if [ -n "$IN_NIX_SHELL" ]; then
          local bg=$1
          local fg=$2
          local content=" NIX"
          PS1+=$(section_end $fg $bg)
          PS1+=$(section_content $fg $bg "$content ")
          __last_color=$bg
        fi
      }

      # -----------------------------------------------------------------------------
      # append to prompt: end the current promptline and start a newline
      function newline_module {
        if [ -n "$__last_color" ]; then
          PS1+=$(section_end $__last_color 'DEFAULT')
        fi
        PS1+="\n"
        unset __last_color
      }

      # -----------------------------------------------------------------------------
      function pureline_ps1 {
        __return_code=$?      # save the return code
        PS1="\n"

        # load the modules
        for module in "''${!pureline_modules[@]}"; do
          ''${pureline_modules[$module]}
        done

        # final end point
        if [ -n "$__last_color" ]; then
          PS1+=$(section_end $__last_color 'DEFAULT')
        else
          PS1+="$"
        fi

        # cleanup
        PS1+="''${colors[DEFAULT]}\[\e[K\] "
        unset __last_color
        unset __return_code
      }

      # -----------------------------------------------------------------------------

      # define the basic color set
      declare -A colors=(
        [DEFAULT]='\[\e[38;5;12m\]'
        [BASE03]='\[\e[38;5;8m\]'
        [BASE02]='\[\e[38;5;0m\]'
        [BASE01]='\[\e[38;5;10m\]'
        [BASE00]='\[\e[38;5;11m\]'
        [BASE0]='\[\e[38;5;12m\]'
        [BASE1]='\[\e[38;5;14m\]'
        [BASE2]='\[\e[38;5;7m\]'
        [BASE3]='\[\e[38;5;15m\]'
        [YELLOW]='\[\e[38;5;3m\]'
        [ORANGE]='\[\e[38;5;9m\]'
        [RED]='\[\e[38;5;1m\]'
        [MAGENTA]='\[\e[38;5;5m\]'
        [VIOLET]='\[\e[38;5;13m\]'
        [BLUE]='\[\e[38;5;4m\]'
        [CYAN]='\[\e[38;5;6m\]'
        [GREEN]='\[\e[38;5;2m\]'
        [BLACK]='\[\e[38;5;16m\]'

        [BG_DEFAULT]='\[\e[48;5;8m\]'
        [BG_BASE03]='\[\e[48;5;8m\]'
        [BG_BASE02]='\[\e[48;5;0m\]'
        [BG_BASE01]='\[\e[48;5;10m\]'
        [BG_BASE00]='\[\e[48;5;11m\]'
        [BG_BASE0]='\[\e[48;5;12m\]'
        [BG_BASE1]='\[\e[48;5;14m\]'
        [BG_BASE2]='\[\e[48;5;7m\]'
        [BG_BASE3]='\[\e[48;5;15m\]'
        [BG_YELLOW]='\[\e[48;5;3m\]'
        [BG_ORANGE]='\[\e[48;5;9m\]'
        [BG_RED]='\[\e[48;5;1m\]'
        [BG_MAGENTA]='\[\e[48;5;5m\]'
        [BG_VIOLET]='\[\e[48;5;13m\]'
        [BG_BLUE]='\[\e[48;5;4m\]'
        [BG_CYAN]='\[\e[48;5;6m\]'
        [BG_GREEN]='\[\e[48;5;2m\]'
        [BG_BLACK]='\[\e[48;5;16m\]'
      )

      # define symbols
      declare -A symbols=(
        [hard_separator]=""
        [soft_separator]=""
        [git]=""
        [lock]=""
        [flag]="⚑"
        [plus]="✚"
        [tick]="✔"
        [cross]="✘"
        [enter]="⏎"
        [prompt]="λ"
        [battery_charging]="⚡"
        [battery_discharging]="▮"
        [untracked]="?"
        [stash]="☰"
        [ahead]="⬆"
        [behind]="⬇"
      )

      # define default modules to load
      declare -a pureline_modules=(
        'root_module        RED         BASE3'
        'user_host_module   YELLOW      ORANGE      BASE3'
        'path_module        BLUE        BASE3       3'
        'read_only_module   RED         BASE3'
        'git_module         GREEN       BASE3       ORANGE'
        'newline_module'
        'nix_shell_module   CYAN        BASE3'
        'return_code_module RED         BASE3'
        'prompt_module      BASE02      BASE0'
      )

      # dynamically set the  PS1
      PROMPT_COMMAND="pureline_ps1; $PROMPT_COMMAND"
    '';

    dircolors = ''
      # Term Section
      TERM Eterm
      TERM ansi
      TERM color-xterm
      TERM con132x25
      TERM con132x30
      TERM con132x43
      TERM con132x60
      TERM con80x25
      TERM con80x28
      TERM con80x30
      TERM con80x43
      TERM con80x50
      TERM con80x60
      TERM cons25
      TERM console
      TERM cygwin
      TERM dtterm
      TERM dvtm
      TERM dvtm-256color
      TERM eterm-color
      TERM fbterm
      TERM gnome
      TERM gnome-256color
      TERM jfbterm
      TERM konsole
      TERM konsole-256color
      TERM kterm
      TERM linux
      TERM linux-c
      TERM mach-color
      TERM mlterm
      TERM putty
      TERM putty-256color
      TERM rxvt
      TERM rxvt-256color
      TERM rxvt-cygwin
      TERM rxvt-cygwin-native
      TERM rxvt-unicode
      TERM rxvt-unicode256
      TERM rxvt-unicode-256color
      TERM screen
      TERM screen-16color
      TERM screen-16color-bce
      TERM screen-16color-s
      TERM screen-16color-bce-s
      TERM screen-256color
      TERM screen-256color-bce
      TERM screen-256color-s
      TERM screen-256color-bce-s
      TERM screen-256color-italic
      TERM screen-bce
      TERM screen-w
      TERM screen.linux
      TERM screen.xterm-256color
      TERM st
      TERM st-meta
      TERM st-256color
      TERM st-meta-256color
      TERM tmux
      TERM tmux-256color
      TERM vt100
      TERM xterm
      TERM xterm-16color
      TERM xterm-256color
      TERM xterm-256color-italic
      TERM xterm-88color
      TERM xterm-color
      TERM xterm-debian
      TERM xterm-kitty
      TERM xterm-termite

      ## Documentation
      #
      # standard colors
      #
      # Below are the color init strings for the basic file types. A color init
      # string consists of one or more of the following numeric codes:
      # Attribute codes:
      # 00=none 01=bold 04=underscore 05=blink 07=reverse 08=concealed
      # Text color codes:
      # 30=black 31=red 32=green 33=yellow 34=blue 35=magenta 36=cyan 37=white
      # Background color codes:
      # 40=black 41=red 42=green 43=yellow 44=blue 45=magenta 46=cyan 47=white
      #
      #
      # 256 color support
      # see here: http://www.mail-archive.com/bug-coreutils@gnu.org/msg11030.html)
      #
      # Text 256 color coding:
      # 38;5;COLOR_NUMBER
      # Background 256 color coding:
      # 48;5;COLOR_NUMBER

      ## Special files

      NORMAL                00;38;5;244       # no color code at all
      #FILE                 00                # regular file: use no color at all
      RESET                 0                 # reset to "normal" color
      DIR                   00;38;5;4         # directory
      LINK                  00;38;5;1         # symbolic link. (If you set this to 'target' instead of a
                                              # numerical value, the color is as for the file pointed to.)
      MULTIHARDLINK         00                # regular file with more than one link
      FIFO                  48;5;0;38;5;9;01  # pipe
      SOCK                  48;5;0;38;5;9;01  # socket
      DOOR                  48;5;0;38;5;9;01  # door
      BLK                   48;5;0;38;5;14;01 # block device driver
      CHR                   48;5;0;38;5;14;01 # character device driver
      ORPHAN                48;5;0;38;5;1     # symlink to nonexistent file, or non-stat'able file
      SETUID                48;5;7;38;5;7     # file that is setuid (u+s)
      SETGID                48;5;5;38;5;7     # file that is setgid (g+s)
      CAPABILITY            30;41             # file with capability
      STICKY_OTHER_WRITABLE 48;5;2;38;5;7     # dir that is sticky and other-writable (+t,o+w)
      OTHER_WRITABLE        48;5;2;38;5;4     # dir that is other-writable (o+w) and not sticky
      STICKY                48;5;5;38;5;15    # dir with the sticky bit set (+t) and not other-writable
      EXEC                  00;38;5;2         # This is for files with execute permission:

      ## Archives or compressed (violet + bold for compression)
      .tar                  00;38;5;13
      .tgz                  00;38;5;13
      .arj                  00;38;5;13
      .taz                  00;38;5;13
      .lzh                  00;38;5;13
      .lzma                 00;38;5;13
      .tlz                  00;38;5;13
      .txz                  00;38;5;13
      .zip                  00;38;5;13
      .z                    00;38;5;13
      .Z                    00;38;5;13
      .dz                   00;38;5;13
      .gz                   00;38;5;13
      .lz                   00;38;5;13
      .xz                   00;38;5;13
      .bz2                  00;38;5;13
      .bz                   00;38;5;13
      .tbz                  00;38;5;13
      .tbz2                 00;38;5;13
      .tz                   00;38;5;13
      .deb                  00;38;5;13
      .rpm                  00;38;5;13
      .jar                  00;38;5;13
      .rar                  00;38;5;13
      .ace                  00;38;5;13
      .zoo                  00;38;5;13
      .cpio                 00;38;5;13
      .7z                   00;38;5;13
      .rz                   00;38;5;13
      .apk                  00;38;5;13
      .gem                  00;38;5;13

      # Image formats (yellow)
      .jpg                  00;38;5;3
      .JPG                  00;38;5;3 #stupid but needed
      .jpeg                 00;38;5;3
      .gif                  00;38;5;3
      .bmp                  00;38;5;3
      .pbm                  00;38;5;3
      .pgm                  00;38;5;3
      .ppm                  00;38;5;3
      .tga                  00;38;5;3
      .xbm                  00;38;5;3
      .xpm                  00;38;5;3
      .tif                  00;38;5;3
      .tiff                 00;38;5;3
      .png                  00;38;5;3
      .PNG                  00;38;5;3
      .svg                  00;38;5;3
      .svgz                 00;38;5;3
      .mng                  00;38;5;3
      .pcx                  00;38;5;3
      .dl                   00;38;5;3
      .xcf                  00;38;5;3
      .xwd                  00;38;5;3
      .yuv                  00;38;5;3
      .cgm                  00;38;5;3
      .emf                  00;38;5;3
      .eps                  00;38;5;3
      .CR2                  00;38;5;3
      .ico                  00;38;5;3

      # Files of special interest (base1)
      .tex                  00;38;5;14
      .rdf                  00;38;5;14
      .owl                  00;38;5;14
      .n3                   00;38;5;14
      .ttl                  00;38;5;14
      .nt                   00;38;5;14
      .torrent              00;38;5;14
      .xml                  00;38;5;14
      *Makefile             00;38;5;14
      *Rakefile             00;38;5;14
      *Dockerfile           00;38;5;14
      *build.xml            00;38;5;14
      *rc                   00;38;5;14
      *1                    00;38;5;14
      .nfo                  00;38;5;14
      *README               00;38;5;14
      *README.txt           00;38;5;14
      *readme.txt           00;38;5;14
      .md                   00;38;5;14
      *README.markdown      00;38;5;14
      .ini                  00;38;5;14
      .yml                  00;38;5;14
      .yaml                 00;38;5;14
      .cfg                  00;38;5;14
      .conf                 00;38;5;14
      .h                    00;38;5;14
      .hpp                  00;38;5;14
      .c                    00;38;5;14
      .cpp                  00;38;5;14
      .cxx                  00;38;5;14
      .cc                   00;38;5;14
      .objc                 00;38;5;14
      .sqlite               00;38;5;14
      .go                   00;38;5;14
      .sql                  00;38;5;14
      .csv                  00;38;5;14
      .scala                00;38;5;14
      .hs                   00;38;5;14
      .lhs                  00;38;5;14

      # "unimportant" files as logs and backups (base01)
      .log                  00;38;5;10
      .bak                  00;38;5;10
      .aux                  00;38;5;10
      .lof                  00;38;5;10
      .lol                  00;38;5;10
      .lot                  00;38;5;10
      .out                  00;38;5;10
      .toc                  00;38;5;10
      .bbl                  00;38;5;10
      .blg                  00;38;5;10
      *~                    00;38;5;10
      *#                    00;38;5;10
      .part                 00;38;5;10
      .incomplete           00;38;5;10
      .swp                  00;38;5;10
      .tmp                  00;38;5;10
      .temp                 00;38;5;10
      .o                    00;38;5;10
      .pyc                  00;38;5;10
      .class                00;38;5;10
      .cache                00;38;5;10

      # Audio formats (orange)
      .aac                  00;38;5;9
      .au                   00;38;5;9
      .flac                 00;38;5;9
      .mid                  00;38;5;9
      .midi                 00;38;5;9
      .mka                  00;38;5;9
      .mp3                  00;38;5;9
      .mpc                  00;38;5;9
      .ogg                  00;38;5;9
      .opus                 00;38;5;9
      .ra                   00;38;5;9
      .wav                  00;38;5;9
      .m4a                  00;38;5;9
      .axa                  00;38;5;9
      .oga                  00;38;5;9
      .spx                  00;38;5;9
      .xspf                 00;38;5;9

      # Video formats (as audio + bold)
      .mov                  00;38;5;9
      .MOV                  00;38;5;9
      .mpg                  00;38;5;9
      .mpeg                 00;38;5;9
      .m2v                  00;38;5;9
      .mkv                  00;38;5;9
      .ogm                  00;38;5;9
      .mp4                  00;38;5;9
      .m4v                  00;38;5;9
      .mp4v                 00;38;5;9
      .vob                  00;38;5;9
      .qt                   00;38;5;9
      .nuv                  00;38;5;9
      .wmv                  00;38;5;9
      .asf                  00;38;5;9
      .rm                   00;38;5;9
      .rmvb                 00;38;5;9
      .flc                  00;38;5;9
      .avi                  00;38;5;9
      .fli                  00;38;5;9
      .flv                  00;38;5;9
      .gl                   00;38;5;9
      .m2ts                 00;38;5;9
      .divx                 00;38;5;9
      .webm                 00;38;5;9
      .axv                  00;38;5;9
      .anx                  00;38;5;9
      .ogv                  00;38;5;9
      .ogx                  00;38;5;9
    '';

  };

  environment.etc."inputrc".text = ''
    # Make Tab autocomplete regardless of filename case
    set completion-ignore-case on

    # List all matches in case multiple possible completions are possible
    set show-all-if-ambiguous on

    # Immediately add a trailing slash when autocompleting symlinks to directories
    set mark-symlinked-directories on

    # Use the text that has already been typed as the prefix for searching through
    # commands (i.e. more intelligent Up/Down behavior)
    "\e[B": history-search-forward
    "\e[A": history-search-backward

    # Do not autocomplete hidden files unless the pattern explicitly begins with a dot
    set match-hidden-files off

    # Show all autocomplete results at once
    set page-completions off

    # If there are more than 200 possible completions for a word, ask to show them all
    set completion-query-items 200

    # Show extra file information when completing, like `ls -F` does
    set visible-stats on

    # Be more intelligent when autocompleting by also looking at the text after
    # the cursor. For example, when the current line is "cd ~/src/mozil", and
    # the cursor is on the "z", pressing Tab will not autocomplete it to "cd
    # ~/src/mozillail", but to "cd ~/src/mozilla". (This is supported by the
    # Readline used by Bash 4.)
    set skip-completed-text on

    # Allow UTF-8 input and output, instead of showing stuff like $'\0123\0456'
    set input-meta on
    set output-meta on
    set convert-meta off

    # Use Alt/Meta + Delete to delete the preceding word
    "\e[3;3~": kill-word
  '';

}

