{ config, lib, pkgs, ...}:

with lib;

let

  neovim = pkgs.neovim.override {
    configure = {
      packages.myVimPackage = with pkgs.vimPlugins; {
        start = [
          ale
          colors-solarized
          commentary
          fugitive
          fzf-vim
          fzfWrapper
          ghc-mod-vim
          gist-vim
          haskell-vim
          hoogle
          lushtags
          multiple-cursors
          neco-ghc
          deoplete-nvim
          nerdcommenter
          nerdtree
          polyglot
          purescript-vim
          repeat
          surround
          Tabular
          Tagbar
          UltiSnips
          undotree
          vim-airline
          vim-airline-themes
          vim-gitgutter
          vim-nerdtree-tabs
          vim-nix
          # vim-rooter
          vim-scala
          vim-signify
          vimproc
          webapi-vim
        ];
        opt = [];
      };

      customRC = builtins.readFile ../config/vim/vimrc;
    };
    withPython = true;
    withPython3 = true;
    withRuby = true;
  };

in {

  environment.systemPackages =
    [
      neovim
    ];

  environment.variables.EDITOR = "${neovim}/bin/nvim";

  environment.etc."vim/snippets/haskell.snip".source = ../config/vim/snippets/haskell.snip;

}
