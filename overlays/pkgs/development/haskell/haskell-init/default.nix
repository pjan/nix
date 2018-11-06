{ fetchFromGitHub, git, stack, stdenv, writeShellScriptBin }:

let
  stack-templates = stdenv.mkDerivation rec {
    name = "stack-templates";

    src = fetchFromGitHub {
      owner = "pjan";
      repo = "stack-templates";
      rev = "87e2f6c687d7436fd8a465f80ff7e833390af396";
      sha256 = "0sn2722w40gqqmi92l32qjsdjxfnh4ahfzxahvkl6vc94xd6bxrj";
    };

    installPhase = ''
      mkdir -p $out/share
      cp *.hsfiles $out/share
    '';

  };

in writeShellScriptBin "haskell-init" ''
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

