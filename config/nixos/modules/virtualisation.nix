{ config, lib, pkgs, ... }:

let

in {

  virtualisation.docker.enable = true;

  environment.systemPackages = with pkgs; [
    docker_compose
  ];

}

