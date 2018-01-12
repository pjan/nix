self: super: {

  git-tools      = super.callPackage ./envs/git-tools.nix      { };
  haskell-tools  = super.callPackage ./envs/haskell-tools.nix  { };
  lang-tools     = super.callPackage ./envs/lang-tools.nix     { };
  network-tools  = super.callPackage ./envs/network-tools.nix  { };
  nix-tools      = super.callPackage ./envs/nix-tools.nix      { };
  security-tools = super.callPackage ./envs/security-tools.nix { };
  system-tools   = super.callPackage ./envs/system-tools.nix   { };

}

