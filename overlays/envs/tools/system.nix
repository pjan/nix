{ pkgs }:

pkgs.buildEnv {
  name = "system-tools";
  paths = with pkgs; [
    aspell
    aspellDicts.en
    aspellDicts.nl
    bash-completion
    bashInteractive
    nix-bash-completions
    coreutils
		csvkit
    ctop
    cvc4
    direnv
    exiv2
    findutils
    fzf
    gnugrep
    gnuplot
    gnused
    gnutar
    htop
    less
    gettext
    htop
    # multitail
    renameutils
    # pass
    pass-otp
    parallel
    pv
    ripgrep
    rlwrap
    screen
    silver-searcher
    srm
    sqlite
    time
    tree
    unrar
    unzip
    watch
    xz
    z3
    youtube-dl
    zip
  ];
}
