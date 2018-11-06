{ config, lib, pkgs, ... }:

{

  programs.home-manager = {
    enable = true;
    configPath = ../../home-manager;
  };

}

