{ config, pkgs, ... }: {

  programs.vim = {

    enable = true;

    enableSensible = true;

    plugins = [
      {
        names = [
          "ale"
          "colors-solarized"
          "commentary"
          "fugitive"
          "fzf-vim"
          "fzfWrapper"
          "ghc-mod-vim"
          "gist-vim"
          "haskell-vim"
          "hoogle"
          "lushtags"
          "multiple-cursors"
          "neco-ghc"
          "neocomplete"
          "neosnippet"
          "nerdcommenter"
          "nerdtree"
          "polyglot"
          "purescript-vim"
          "repeat"
          "surround"
          "Tabular"
          "Tagbar"
          "undotree"
          # "vim2hs" # haskell-vim is better
          "vim-airline"
          "vim-airline-themes"
          "vim-gitgutter"
          "vim-nerdtree-tabs"
          "vim-nix"
          "vim-rooter"
          "vim-scala"
          "vim-signify"
          "vimproc"
          "webapi-vim"
        ];
      }
    ];

    vimConfig = builtins.readFile ../../shared/config/vim/vimrc;
  };

  environment.etc."vim/snippets/haskell.snip".source = ../../shared/config/vim/snippets/haskell.snip;

}
