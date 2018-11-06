{ pkgs }:

pkgs.buildEnv {
  name = "network-tools";
  paths = with pkgs; [
    adns
    aria2
    cacert
    dnsutils
    httrack
    iperf
    lftp
    mitmproxy
    mtr
    ngrep
    nmap
    openssl
    openvpn
    pdnsd
    privoxy
    rclone
    rsync
    sipcalc
    spiped
    weechat
    w3m
    wget
  ];
}
