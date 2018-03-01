{ fetchFromGitHub, git, stack, stdenv, writeShellScriptBin }:

let
  stack-templates = stdenv.mkDerivation rec {
    name = "stack-templates";

    src = fetchFromGitHub {
      owner = "pjan";
      repo = "stack-templates";
      rev = "0cd9c3a1cef31569e9b31df30cff180eb92cc955";
      sha256 = "19aj6kjgljayd1b595ib8w7630q2sn47rd4gq2qvg6c83cx8p2ib";
    };

    installPhase = ''
      mkdir -p $out/share
      cp *.hsfiles $out/share
    '';

  };

in writeShellScriptBin "hi" ''
  length=$(($#-1))

  case "$2" in
    default)
      TEMPLATE="${stack-templates}/share/default.hsfiles"
      ;;
    *)
      TEMPLATE=$2
      ;;
  esac

  set -- ''${@:1:1} $TEMPLATE ''${@:3:$length}
  ${stack}/bin/stack new $@ && cd $1 && rm stack.yaml && ${git}/bin/git init
''

