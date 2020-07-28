{ config, lib, pkgs, ... }:

let

in {

  environment.systemPackages = [ pkgs.direnv ];

  programs.shells.bash.shellInitExtra = ''
    eval "$(${pkgs.direnv}/bin/direnv hook bash)"
  '';

}
