{ pkgs }:

pkgs.buildEnv {
  name = "lang-tools";
  paths = with pkgs; [
    autoconf
    automake
    clang
    cmake
    coreutils
    global
    gmp
    gnumake
    htmlTidy
    idutils
    lean
    libcxx
    libcxxabi
    libtool
    llvm
    mpfr
    ninja
    ott
    pkgconfig
    # R
    ctags
    rtags
    sbcl
    sloccount
  ];
}
