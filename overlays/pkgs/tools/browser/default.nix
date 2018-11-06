{ chromium, workspace, writeShellScriptBin }:

writeShellScriptBin "browser" ''

# Browser instance based on the workspace tag

BROWSER=chromium
WSTAG=$(${workspace}/bin/ws tag)

CONFIGDIR=''${XDG_CONFIG_HOME:-''${HOME}/.config/browser}
CACHEDIR=''${XDG_CACHE_HOME:-''${HOME}/.cache/browser}

# make directories if missing, set no COW for btrfs
[ -d "$CONFIGDIR" ] || { mkdir -p "$CONFIGDIR"; chattr +C "$CONFIGDIR"; }
[ -d "$CACHEDIR" ] || { mkdir -p "$CACHEDIR"; chattr +C "$CACHEDIR"; }

[ -z "$WSTAG" ] && SUFFIX="" || SUFFIX="_$WSTAG"
[ "$WSTAG" = "incognito" ] && INCOGNITO=" --incognito " || INCOGNITO=""

eval $BROWSER $INCOGNITO --user-data-dir=''${CONFIGDIR}/''${BROWSER}''${SUFFIX} ${REMOTE:-} $* \&


''

