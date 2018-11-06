{ pkgs, stdenv }:

let

  buildSymbols = a@{
    name,
    text,
    description,
    ...
  }:
  let

    symbols = pkgs.writeText name text;

  in stdenv.mkDerivation (a // {

    phases = "installPhase";

    installPhase = ''
      mkdir -p $out/etc/X11/xkb/symbols
      install -v -m0644 ${symbols} $out/etc/X11/xkb/symbols/${name}
    '';

    meta = with stdenv.lib; {
      inherit description;
      license = licenses.mit;
      platforms = platforms.unix;
    };
  });

in rec {

  hypers = buildSymbols {
    name = "hypers";
    description = "tab and backslash to hyper to mod4";
    text = ''
      xkb_symbols "basic" {
        key  <TAB> { [ Hyper_L, Hyper_L ] };
        key <BKSL> { [ Hyper_R, Hyper_R ] };
        key <I252> { [ Tab, ISO_Left_Tab ] };
        key <I253> { [ backslash, bar ] };
        modifier_map Mod4 { Super_L, Super_R, Hyper_L, Hyper_R };
      };
    '';
  };

}

