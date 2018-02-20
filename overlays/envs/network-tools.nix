{ pkgs }:

pkgs.buildEnv {
  name = "network-tools";
  paths = with pkgs; [
    adns
    aria2
    cacert
    curl
    dnsutils
    httrack
    iperf
    lftp
    # mitmproxy
    mtr
    ngrep
    nmap
    openssh
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
