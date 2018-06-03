{ wmctrl, writeShellScriptBin }:

writeShellScriptBin "ws" ''

# UNIQUE BROWSER WORKSPACES
# list of workspaces that have a unique browser instance
# and likely have their own chat pplication handled via xmonad

UNIQUE='wrk ggc dm nul'

# INCOGNITO WORKSPACES
# list of workspaces that automatically show an incognito mode browser

INCOGNITO='temp'

main () {
  WS=$(wmctrl -d | grep '*' | rev | cut -d " " -f 1 | rev | tr '[:upper:]' '[:lower:]' | cut -d: -f1 | tr -cd '[[:alpha:]]')

  INCOGNITO=$(echo $INCOGNITO | tr " " "\n" | grep $WS )

  if [ -n "$INCOGNITO" ]
  then
    TAG="incognito"
  else
    TAG=$(echo $UNIQUE $INCOGNITO | tr " " "\n" | grep $WS )
  fi

  case $1 in
    tag) echo -n "$TAG" ;;
    *|name) echo -n "$WS" ;;
  esac
}

main $*

''

