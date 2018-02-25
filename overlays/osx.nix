self: super:

let

  mkAppDerivation =
    { name
    , ...
  } @ args:
    let
      drvName =
        let
          root = builtins.replaceStrings [ " " ] [ "-" ] name;
          suffix =
            if (super.lib.hasAttrByPath [ "meta" "version" ] args)
            then ''-${super.lib.getAttrFromPath [ "meta" "version" ] args}''
            else "";
        in "${root}${suffix}";
    in with super; stdenv.mkDerivation (args // {
      name = drvName;
      buildInputs = [ undmg unzip ];
      phases = [ "unpackPhase" "installPhase" "fixupPhase" ];
      installPhase = ''
        mkdir -p "$out/Applications/${name}.app"
        cp -pR * "$out/Applications/${name}.app"
      '';
    });

in rec {

  osx = {
    inherit mkAppDerivation;
  };

}

