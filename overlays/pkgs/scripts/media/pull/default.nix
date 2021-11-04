{ stdenv, pkgs }:

let lftpConfigFile = pkgs.substituteAll { src = ./mirror.lftp; };

in pkgs.writeShellScriptBin "mm-pull" ''

  lftp -f "${rcloneConfigFile}"

''
