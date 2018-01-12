{ config, pkgs, ... }: {

  environment.shellAliases = {
    # Folder navigation
    ".." = "cd ..";
    "..." = "cd ../..";
    "...." = "cd ../../..";
    "....." = "cd ../../../..";

    # Applications
    g = "git";
    vi = "vim";

    # lsstuff
    ll = "ls -ahlF";
    la = "ls -A";
    lf = "ls -lF | grep --color=never \"^d\"";

    # Get week number
    week = "date +%V";

    # Gzip-enabled curl
    gurl = "curl --compressed";

    # Recursively deleate `.DS_Store` files
    cleanup = "find . -type f -name \"*.DS_Store\" -ls -delete";

    # Flush Directory Service cache
    #flushdns="dscacheutil -flushcache && killall -HUP mDNSResponder"A;

    # Clean up LaunchServices to remove duplicates in the “Open With” menu
    #lscleanup="/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user && killall Finder";

    # IP addresses
    ip = "dig +short myip.opendns.com @resolver1.opendns.com";
    localip = "ipconfig getifaddr en0";
    # environment.shellAliases.ips = "ifconfig -a | grep -o \"inet7\? \(\([0-9]\+\.[0-9]\+\.[0-9]\+\.[0-9]\+\)\|[a-fA-F0-9:]\+\)\" | sed -e \"s/inet6* //\"";

    # Enhanced whois lookup
    whois = "whois -h whois-servers.net";

    # Command line User Agent functions
    GET = "lwp-request -m GET";
    HEAD = "lwp-request -m HEAD";
    POST = "lwp-request -m POST";
    PUT = "lwp-request -m PUT";
    DELETE = "lwp-request -m DELETE";
    TRACE = "lwp-request -m TRACE";
    OPTIONS = "lwp-request -m OPTIONS";

    # PlistBuddy alias
    plistbuddy = "/usr/libexec/PlistBuddy";

    # Disable/Enable spotlight
    spoton = "sudo mdutil -a -i on";
    spotoff = "sudo mdutil -a -i off";

    # Turn the lights off
    afk = "/System/Library/CoreServices/Menu\\ Extras/User.menu/Contents/Resources/CGSession -suspend";
  };

}

