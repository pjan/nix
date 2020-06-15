{ config, lib, pkgs, ... }:

{

  programs.git = {
    enable = true;

    userName = "pjan vandaele";
    userEmail = "pjan@vandaele.io";

    signing = {
      key = "1FE9F3FD598C6559";
      signByDefault = true;
    };

    aliases = {
      # Commit all changes
      ac = "!git add -A && git commit -av";

      # Commit all changes with message
      acm = "!git add -A && git commit -m";

      # Amend the currently staged files to the latest commit
      amend = "commit --amend --reuse-message=HEAD";

      # List of (unique) authors
      authors = ''!"git log --pretty=format:%aN | sort | uniq -c | sort -rn"'';

      # List all branches, verbose
      branches = "branch -av";

      # Clone a repository including all submodules
      cl = "clone --recursive";

      # Commit with message
      cm = "commit -m";

      # Checkout
      co = "checkout";

      # Cherry-pick
      cp = "cherry-pick -s";

      # Credit an author on the latest commit
      credit = ''!f() { git commit --amend --author "$1 <$2>" -C HEAD; }; f'';

      # Show the diff between the latest commit and the current state
      d = ''
        !"git diff-index --quiet HEAD -- || clear; git --no-pager diff --patch-with-stat"'';

      # Show the diff between the nth latest commit (defaults to 1) and the current state
      di = ''
        "!d() { REV=''${1:-1}; git diff --patch-with-stat HEAD~$REV; }; git diff-index --quiet HEAD -- || clear; d"'';

      # Find branches containing commit
      fb = "!f() { git branch -a --contains $1; }; f";

      # Find tags containing commit
      ft = ''"!f() { git describe --always --contains $1; }; f"'';

      # Find commits by source code
      fc = ''
        "!f() { git log --pretty=format:'%C(yellow)%h  %Cblue%ad  %Creset%s%Cgreen  [%cn] %Cred%d' --decorate --date=short -S$1; }; f"'';

      # Find commits by commit message
      fm = ''
        "!f() { git log --pretty=format:'%C(yellow)%h  %Cblue%ad  %Creset%s%Cgreen  [%cn] %Cred%d' --decorate --date=short --grep=$1; }; f"'';

      # Switch to a branch, creating one if necessary
      go = ''
        "!f() { git checkout -b "$1" 2> /dev/null || git checkout "$1"; }; f"'';

      # View abbreviated SHA, description, and history graph of the latest 20 commits
      l = "log --pretty=oneline -n 20 --graph --abbrev-commit";

      # View the full log graph
      lg =
        "log --graph --pretty=format:'%Cred%h%Creset —%Cblue%d%Creset %s %Cgreen(%cr)%Creset' --abbrev-commit --date=relative --show-notes=*";

      # View more detailed log with stats of the latest 10 commits
      ll = "log -n 20 --stat --abbrev-commit";

      # List ignored files
      ls-ignored = "ls-files --exclude-standard --ignored --others";

      # List non-ignored files
      ls-included = "ls-files";

      # Pull fast-forward
      pull = "pull -ff";

      # Pull in remote changes for the current repository and all its submodules
      pull-all = ''!"git pull; git submodule foreach git pull origin master"'';

      # Remote
      r = "remote";

      # Remove branches that have already been merged with master
      # a.k.a. ‘delete merged’
      rdm =
        ''"!git branch --merged | grep -v '\\*' | xargs -n 1 git branch -d"'';

      # Interactive rebase with the given number of latest commits
      reb = ''"!r() { git rebase -i HEAD~$1; }; r"'';

      # List all remotes
      remotes = "remote -v";

      # Remote update pruned
      ru = "remote update --prune";

      # View the current working tree status using the short format
      s = "status -s";

      # Launch git-sh
      sh = "!git-sh";

      # Take a snapshot
      snap = "!git stash && git stash apply";

      # List all stashes
      stashes = "stash list";

      # List all tags
      tags = "tag -l";

      # Undo the last commit
      undo = "reset --soft HEAD^";
    };

    extraConfig = {
      advice = {
        statusHints = false;
        objectNameWarning = "false";
        pushNonFastForward = false;
      };

      apply.whitespace = "fix";
      credential.helper = "osxkeychain";
      ghi.token =
        "!/usr/bin/security find-internet-password -a pjan -s github.com -l 'ghi token' -w";
      help.autocorrect = true;
      hub.protocol = "${pkgs.openssh}/bin/ssh";
      pull.rebase = true;
      rebase.autosquash = true;
      rerere.enabled = true;

      color = {
        decorate = "auto";
        grep = "auto";
        interactive = "auto";
        ui = "auto";
        sh = "auto";
        showbranch = "auto";
      };

      "color \"branch\"" = {
        current = "yellow reverse";
        local = "yellow";
        remote = "green";
      };

      "color \"diff\"" = {
        meta = "yellow bold";
        frag = "magenta bold"; # line info
        old = "red"; # deletions
        new = "green"; # additions
      };

      "color \"sh\"" = {
        branch = "yellow reverse";
        workdir = "blue bold";
        dirty = "red";
        dirty-stash = "red";
        repo-state = "red";
      };

      "color \"status\"" = {
        added = "yellow";
        changed = "green";
        untracked = "cyan";
      };

      core = {
        editor = "${pkgs.vim}/bin/vim";
        trustctime = false;
        pager = "${pkgs.less}/bin/less --tabs=4 -RFX";
        logAllRefUpdates = true;
        precomposeunicode = false;
        whitespace = "space-before-tab,-indent-with-non-tab,trailing-space";
      };

      diff = {
        ignoreSubmodules = "dirty";
        renames = "copies";
        mnemonicprefix = true;
      };

      "filter \"media\"" = {
        required = true;
        clean = "git media clean %f";
        smudge = "git media smudge %f";
      };

      merge = {
        conflictstyle = "diff3";
        log = true;
        stat = true;
      };

      http = {
        sslCAinfo = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";
        sslverify = true;
      };

      push = {
        default = "tracking";
        # recurseSubmodules = "check";
      };

      "url \"git@github.com:\"" = {
        insteadOf = "gh:";
        pushInsteadOf = "github:";
        # pushInsteadOf = "git://github.com";
      };

      "url \"git://github.com/\"" = { instadOf = "github:"; };

      "url \"git@gist.github.com:\"" = {
        insteadOf = "gst:";
        pushInsteadOf = "gist:";
        # pushInsteadOf = "git://gist.github.com";
      };

      "url \"git://gist.github.com/\"" = { insteadOf = "gist:"; };
    };

    ignores = [
      "#*#"
      "*.a"
      "*.aux"
      "*.dylib"
      "*.elc"
      "*.glob"
      "*.la"
      "*.o"
      "*.so"
      "*.v.d"
      "*.vo"
      "*~"
      ".clean"
      ".direnv"
      ".envrc"
      ".envrc.cache"
      ".envrc.override"
      ".ghc.environment.x86_64-darwin-*"
      ".makefile"
      "TAGS"
      "cabal.project.local"
      "dist-newstyle"
      "result"
      "result-*"
      "tags"
    ];

  };

}
