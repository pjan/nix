self: super:

with super.vimPlugins; with super.vimUtils; with super; rec {

  vimPlugins = super.vimPlugins // {

    neco-ghc = buildVimPluginFrom2Nix {
      name = "neco-ghc-2018-03-05";
      src = fetchgit {
        url = "https://github.com/pjan/neco-ghc";
        rev = "78bcf10087e471cb1961967cd0bcc389be626092";
        sha256 = "00qc3c0ss17firq2d4z1c42c0wx3xgpvdafpz6sdwy4raq8ackzy";
      };
      dependencies = [];
    };

  };

}

