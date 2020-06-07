{ config, lib, pkgs, ... }:

let

  homeDirectory = config.home.homeDirectory;
  dataHome = config.xdg.dataHome;

in {

  launchd.user.agents.aria2c = {
    script = ''
      if [[ ! -d ${dataHome}/aria ]]; then
        mkdir -p ${dataHome}/aria
      fi

      ${pkgs.aria2}/bin/aria2c --enable-rpc \
        --dir ${homeDirectory}/Downloads \
        --log ${dataHome}/aria/aria2c.log \
        --check-integrity \
        --continue \
        --rpc-listen-all=true \
        --rpc-allow-origin-all=true
    '';
    serviceConfig.RunAtLoad = true;
    serviceConfig.KeepAlive = true;
  };

}
