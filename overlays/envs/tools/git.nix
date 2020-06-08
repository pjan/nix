{ pkgs }:

pkgs.buildEnv {
  name = "git-tools";
  paths = with pkgs; [
    colordiff
    diffstat
    diffutils
    ghi
    gist
    git
    gitRepo
    # gitAndTools.git-imerge
    # gitAndTools.gitFull
    # gitAndTools.gitflow
    gitAndTools.hub
    gitAndTools.tig
    gitAndTools.git-annex
    gitAndTools.git-annex-remote-rclone
    patch
    patchutils
    travis
  ];
}
