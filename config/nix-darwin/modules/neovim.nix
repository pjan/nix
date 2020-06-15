{ config, lib, pkgs, ... }:

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
          # ghc-mod-vim
          # haskell-vim
          # hoogle
          lushtags
          multiple-cursors
          # neco-ghc
          deoplete-nvim
          # LanguageClient-neovim
          neosnippet
          neosnippet-snippets
          nerdcommenter
          nerdtree
          polyglot
          purescript-vim
          repeat
          surround
          Tabular
          Tagbar
          # UltiSnips
          undotree
          vim-airline
          vim-airline-themes
          vim-gist
          vim-gitgutter
          vim-nerdtree-tabs
          vim-nix
          # vim-rooter
          vim-scala
          vim-signify
          vimproc
          webapi-vim
        ];
        opt = [ ];
      };

      customRC = builtins.readFile ../../resources/vim/vimrc;
    };
    withPython = true;
    withPython3 = true;
    withRuby = true;
  };

in {

  environment.systemPackages = [ neovim ];

  environment.variables.EDITOR = "${neovim}/bin/nvim";

}
