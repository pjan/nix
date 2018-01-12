{ ... }: {

  system.stateVersion = 2;
  services.activate-system.enable = true;

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowBroken = true;
    };

    overlays =
      let
        path = ../overlays;
      in with builtins;
        map (n: import (path + ("/" + n)))
            (filter (n: match ".*\\.nix" n != null ||
                        pathExists (path + ("/" + n + "/default.nix")))
                        (attrNames (readDir path)));
  };

  require = [
    ./darwin/nix.nix
  ];

}
