{stdenv, writeShellScriptBin }:

writeShellScriptBin "proxy-toggle" ''
#!${stdenv.shell}

usage () {
  cat <<EOM
Usage: proxy-toggle [options] on/off

  -h | --help        Display this message
       --service     Network service . Defaults to Wi-Fi
       --server      Proxy server address. Defaults to 127.0.0.1
       --port        Proxy server port. Defaults to 8118
EOM
}

main () {
  while getopts hpdv:-: OPT
  do
      if [[ $OPT == - ]]
      then
          OPT=''${OPTARG%%=*}
          if [[ "$OPT" == "$OPTARG" ]]
          then
              OPTARG=''${*:OPTIND:1}
              let OPTIND=$OPTIND+1
          else
              OPTARG=''${OPTARG#*=}
              echo $OPTARG
          fi
      fi

      case $OPT in
              h|help) usage; exit 0;;
             service) SERVICE=$OPTARG;;
              server) SERVER=$OPTARG;;
                port) PORT=$OPTARG;;
          ?) exit 1;;
          *) echo "$0: illegal option --$OPT"; exit 1;;
      esac
  done

  if [ -z "$SERVICE" ]; then
    SERVICE="Wi-Fi"
  fi

  if [ -z "$SERVER" ]; then
    SERVER="127.0.0.1"
  fi

  if [ -z "$PORT" ]; then
    PORT=8118
  fi

  shift $((OPTIND-1))

  while [[ $# > 0 ]]
  do
    case "$1" in
      on)
        networksetup -setwebproxystate $SERVICE on
        networksetup -setwebproxy $SERVICE $SERVER $PORT off
        networksetup -setsecurewebproxystate $SERVICE on
        networksetup -setsecurewebproxy $SERVICE $SERVER $PORT off
        echo 'Web proxy is on'
      shift
      ;;
      off)
        networksetup -setwebproxystate $SERVICE off
        networksetup -setsecurewebproxystate $SERVICE off
        echo 'Web proxy is off'
      shift
      ;;
    esac
  done
}

main $*

''
