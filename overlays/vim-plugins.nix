self: super:

with super.vimPlugins; with super.vimUtils; with super; rec {

  vimPlugins = super.vimPlugins // {

    neco-ghc = buildVimPluginFrom2Nix {
      name = "neco-ghc-2018-03-05";
      src = fetchgit {
        url = "https://github.com/pjan/neco-ghc";
        rev = "42d386e80f9eb9d0931852b13039968575d534ee";
        sha256 = "0igzvjmknhxpqsqmwlmxgiqw1yjsdw40fy47r649cn4zi09ppi7p";
      };
      dependencies = [];
    };

  };

}

