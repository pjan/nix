{ stdenv, python2 }:

stdenv.mkDerivation {
  name = "myscript";
  buildInputs = [
    python2
  ];
  unpackPhase = "true";
  installPhase = ''
    mkdir -p $out/bin
    cp ${./abspath} $out/bin/abspath
    chmod +x $out/bin/abspath
  '';
}
