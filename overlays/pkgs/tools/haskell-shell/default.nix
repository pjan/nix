{ nix, stdenv, writeShellScriptBin }:

writeShellScriptBin "haskell-shell" ''
#!${stdenv.shell}

usage () {
  cat <<EOM
Usage: haskell-shell [options] [packages]

  -h | --help        Display this message
  -v | --version     Compiler version
  -p |               Enable profiling
  -d |               Enable hoogle
EOM
}

main () {
  while getopts hpdv:-: OPT
  do
      if [[ $OPT == - ]]
      then
          OPT=''${OPTARG%%=*}
          if [[ "$OPT" == "$OPTARG" ]]
          then
              OPTARG=''${*:OPTIND:1}
              let OPTIND=$OPTIND+1
          else
              OPTARG=''${OPTARG#*=}
              echo $OPTARG
          fi
      fi

      case $OPT in
              h|help) usage; exit 0;;
           v|version) VERSION=$OPTARG;;
                   p) PROFILING=1;;
                   d) HOOGLE=1;;
          ?) exit 1;;
          *) echo "$0: illegal option --$OPT"; exit 1;;
      esac
  done

  shift $((OPTIND-1))

  pkgs=$@

  if [[ $# -lt 1 ]]; then
    pkgstr=""
  else
    pkgstr=", pkgs: $@"
  fi

  if [ -z "$VERSION" ]; then

    echo "You must at least provide a ghc version (e.g. ghc822)"

  else

    if [ -z "$PROFILING" ] && [ -z "$HOOGLE" ]; then

      echo "Starting haskell shell, ghc: $VERSION$pkgstr"
      nix-shell -p "haskell.packages.$VERSION.ghcWithPackages (pkgs: with pkgs; [$pkgs])"

    elif [ -z "$PROFILING" ]; then

      echo "Starting haskell shell with hoogle, ghc: $VERSION$pkgstr"
      nix-shell -p "haskell.packages.$VERSION.ghcWithHoogle (pkgs: with pkgs; [$pkgs])"

    elif [ -z "$HOOGLE" ]; then

      echo "Starting haskell profiling shell, ghc: $VERSION$pkgstr"
      nix-shell -p "(haskell.packages.$VERSION.override { overrides = self: super: { mkDerivation = args: super.mkDerivation (args // { enableLibraryProfiling = true; }); }; }).ghcWithPackages (pkgs: with pkgs; [$pkgs])"

    else

      echo "Starting haskell profiling shell with hoogle, ghc: $VERSION$pkgstr"
      nix-shell -p "(haskell.packages.$VERSION.override { overrides = self: super: { mkDerivation = args: super.mkDerivation (args // { enableLibraryProfiling = true; }); }; }).ghcWithHoogle (pkgs: with pkgs; [$pkgs])"

    fi

  fi
}

main $*

''

