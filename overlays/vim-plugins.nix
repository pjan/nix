self: super:

with super.vimPlugins; with super.vimUtils; with super; rec {

  vimPlugins = super.vimPlugins // {

    neco-ghc-lushtags = buildVimPluginFrom2Nix {
      name = "neco-ghc-lushtags-2017-03-17";
      src = fetchgit {
        url = "https://github.com/eagletmt/neco-ghc";
        rev = "faa033c05e6a6470d3d780e3931b4c9c72042009";
        sha256 = "01l5n4x94sb6bhjhjx2sibs8gm3zla7hb6szdfgbdmdf7jlzazak";
      };
      dependencies = [];
    };

  };

}

