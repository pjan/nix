{ pkgs }:

pkgs.buildEnv {
  name = "lang-tools";
  paths = with pkgs; [
    autoconf
    automake
    clang
    cmake
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
    R
    rtags
    sbcl
    sloccount
    #verasco
  ];
}
