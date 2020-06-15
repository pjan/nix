{ config, lib, pkgs, ... }:

let

  homeDirectory = config.home.homeDirectory;
  dataHome = config.xdg.dataHome;

  privoxyConf = name: port: ''
    user-manual ${pkgs.privoxy}/share/doc/privoxy/user-manual/
    confdir ${pkgs.privoxy}/etc
    logdir ${dataHome}/privoxy
    actionsfile /etc/privoxy/match-all.action
    actionsfile default.action
    actionsfile user.action
    filterfile default.filter
    filterfile user.filter
    logfile ${name}.log
    listen-address 127.0.0.1:${port}
    toggle 1
    enable-remote-toggle 0
    enable-remote-http-toggle 0
    enable-edit-actions 0
    enforce-blocks 0
    buffer-limit 4096
    enable-proxy-authentication-forwarding 0
    forwarded-connect-retries 0
    accept-intercepted-requests 0
    allow-cgi-request-crunching 0
    split-large-forms 0
    keep-alive-timeout 5
    tolerate-pipelining 1
    socket-timeout 300
    debug 1
    forward-socks5t / 127.0.0.1:9050 .
    forward 192.168.*.*/ .
    forward 10.*.*.*/ .
    forward 127.*.*.*/ .
    forward localhost/ .
  '';

  torConf = name: port: ''
    SOCKSPort 127.0.0.1:${port}
    SOCKSPolicy accept 127.0.0.1/32
    SOCKSPolicy reject *
    Log notice file ${dataHome}/tor/${name}.log
    DataDirectory ${dataHome}/tor/${name}
  '';

in {

  environment.systemPackages = [ pkgs.tor pkgs.proxy-toggle ];

  launchd.user.agents = let
    runCommand = command: {
      inherit command;
      serviceConfig.RunAtLoad = true;
      serviceConfig.KeepAlive = true;
    };

  in {

    haproxy = runCommand "${pkgs.haproxy}/bin/haproxy -- /etc/haproxy.conf";

    privoxy1 =
      runCommand "${pkgs.privoxy}/bin/privoxy --no-daemon /etc/privoxy/config1";
    privoxy2 =
      runCommand "${pkgs.privoxy}/bin/privoxy --no-daemon /etc/privoxy/config2";
    privoxy3 =
      runCommand "${pkgs.privoxy}/bin/privoxy --no-daemon /etc/privoxy/config3";
    privoxy4 =
      runCommand "${pkgs.privoxy}/bin/privoxy --no-daemon /etc/privoxy/config4";
    privoxy5 =
      runCommand "${pkgs.privoxy}/bin/privoxy --no-daemon /etc/privoxy/config5";
    privoxy6 =
      runCommand "${pkgs.privoxy}/bin/privoxy --no-daemon /etc/privoxy/config6";
    privoxy7 =
      runCommand "${pkgs.privoxy}/bin/privoxy --no-daemon /etc/privoxy/config7";
    privoxy8 =
      runCommand "${pkgs.privoxy}/bin/privoxy --no-daemon /etc/privoxy/config8";
    privoxy9 =
      runCommand "${pkgs.privoxy}/bin/privoxy --no-daemon /etc/privoxy/config9";

    tor1 = runCommand "${pkgs.tor}/bin/tor -f /etc/torrc1";
    tor2 = runCommand "${pkgs.tor}/bin/tor -f /etc/torrc2";
    tor3 = runCommand "${pkgs.tor}/bin/tor -f /etc/torrc3";
    tor4 = runCommand "${pkgs.tor}/bin/tor -f /etc/torrc4";
    tor5 = runCommand "${pkgs.tor}/bin/tor -f /etc/torrc5";
    tor6 = runCommand "${pkgs.tor}/bin/tor -f /etc/torrc6";
    tor7 = runCommand "${pkgs.tor}/bin/tor -f /etc/torrc7";
    tor8 = runCommand "${pkgs.tor}/bin/tor -f /etc/torrc8";
    tor9 = runCommand "${pkgs.tor}/bin/tor -f /etc/torrc9";

  };

  environment.etc = {

    "haproxy.conf".text = ''
      global
          maxconn 4096
          ulimit-n 65536
          quiet
          nbproc 1
          nbthread 16
          user pjan
          group staff
      defaults
          retries 3
          option redispatch
          maxconn 2000
          timeout connect 5s
          timeout client 5s
          timeout server 5s
      listen privoxytor
          bind :8118
          mode tcp
          balance roundrobin
          server privoxy1 127.0.0.1:8119
          server privoxy2 127.0.0.1:8129
          server privoxy3 127.0.0.1:8139
          server privoxy4 127.0.0.1:8149
          server privoxy5 127.0.0.1:8159
          server privoxy6 127.0.0.1:8169
          server privoxy7 127.0.0.1:8179
          server privoxy8 127.0.0.1:8189
          server privoxy9 127.0.0.1:8199
      listen socks
          bind :9050
          mode tcp
          balance roundrobin
          server tor1 127.0.0.1:9051
          server tor2 127.0.0.1:9061
          server tor3 127.0.0.1:9071
          server tor4 127.0.0.1:9081
          server tor5 127.0.0.1:9091
          server tor6 127.0.0.1:9101
          server tor7 127.0.0.1:9111
          server tor8 127.0.0.1:9121
          server tor9 127.0.0.1:9131
    '';

    "privoxy/config1".text = privoxyConf "privoxy1" "8119";
    "privoxy/config2".text = privoxyConf "privoxy2" "8129";
    "privoxy/config3".text = privoxyConf "privoxy3" "8139";
    "privoxy/config4".text = privoxyConf "privoxy4" "8149";
    "privoxy/config5".text = privoxyConf "privoxy5" "8159";
    "privoxy/config6".text = privoxyConf "privoxy6" "8169";
    "privoxy/config7".text = privoxyConf "privoxy7" "8179";
    "privoxy/config8".text = privoxyConf "privoxy8" "8189";
    "privoxy/config9".text = privoxyConf "privoxy9" "8199";

    "privoxy/match-all.action".text = ''
      {+change-x-forwarded-for{block} \
       +client-header-tagger{css-requests} \
       +client-header-tagger{image-requests} \
       +client-header-tagger{range-requests} \
       +deanimate-gifs{last} \
       +filter{refresh-tags} \
       +filter{img-reorder} \
       +filter{banners-by-size} \
       +filter{webbugs} \
       +filter{jumping-windows} \
       +filter{ie-exploits} \
       +hide-from-header{block} \
       +hide-referrer{conditional-block} \
       +session-cookies-only \
       +set-image-blocker{pattern} \
      }
      / # Match all URLs
    '';

    "torrc1".text = torConf "tor1" "9051";
    "torrc2".text = torConf "tor2" "9061";
    "torrc3".text = torConf "tor3" "9071";
    "torrc4".text = torConf "tor4" "9081";
    "torrc5".text = torConf "tor5" "9091";
    "torrc6".text = torConf "tor6" "9101";
    "torrc7".text = torConf "tor7" "9111";
    "torrc8".text = torConf "tor8" "9121";
    "torrc9".text = torConf "tor9" "9131";

  };

  programs.shells.bash.shellInitExtra = ''
    for i in privoxy tor; do
      dir=${dataHome}/$i
      if [[ ! -d $dir ]]; then mkdir -p $dir; fi
    done
  '';

}
