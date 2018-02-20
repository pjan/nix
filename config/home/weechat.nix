{ config, pkgs, ... }:

with config; {

  home.sessionVariables."WEECHAT_HOME" = "${xdg.configHome}/weechat";

  xdg.configFile = {
    "weechat/perl/autoload/perlexec.pl".source = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/weechat/scripts/d1ade95b4149505fef56ac7e5727d5b4e3d5c99f/perl/perlexec.pl";
      sha256 = "1sbnm70djsa69zx36v85sx9ip7mdsbk2fay1x0y30n800n76x9jk";
    };
    "weechat/python/autoload/autosort.py".source = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/weechat/scripts/d1ade95b4149505fef56ac7e5727d5b4e3d5c99f/python/autosort.py";
      sha256 = "1n01wiinvf4ss00slgb8ljbdz0ykamyybr9qrx8i1lh5387pbmzi";
    };
    "weechat/python/autoload/buffer_autoset.py".source = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/weechat/scripts/d1ade95b4149505fef56ac7e5727d5b4e3d5c99f/python/buffer_autoset.py";
      sha256 = "1hvnk6vskxmwsjsagpyfsghl629nsqghinwjhprx6yvvhp07wrb0";
    };
    "weechat/python/autoload/grep.py".source = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/weechat/scripts/d1ade95b4149505fef56ac7e5727d5b4e3d5c99f/python/grep.py";
      sha256 = "15wk0mflj7lrqb6knxqdmdd4pxs1c8k7h6r92sh8q4rw94pnwa7j";
    };
    "weechat/python/autoload/text_item.py".source = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/weechat/scripts/d1ade95b4149505fef56ac7e5727d5b4e3d5c99f/python/text_item.py";
      sha256 = "167mx7wiphanzga39549nhqdxy81a3gq7h2pvdcsp96smdm19gac";
    };
  };

}
