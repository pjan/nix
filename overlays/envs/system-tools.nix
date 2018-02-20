{ pkgs }:

pkgs.buildEnv {
  name = "system-tools";
  paths = with pkgs; [
    aspell
    aspellDicts.en
    aspellDicts.nl
    bashInteractive
    bash-completion
    nix-bash-completions
    coreutils
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
    multitail
    renameutils
    p7zip
    pass
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
    zip
    zsh
  ];
}
