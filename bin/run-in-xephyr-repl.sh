#!/bin/sh -eu

################################################################################
usage () {
  cat <<EOF
Usage: run-in-xephyr.sh [options]

  -d NxN  Set the screen size to NxN
  -h      This message
  -n NUM  Set the internal DISPLAY to NUM
  -s NUM  Set the number of screens to NUM
EOF
}

################################################################################
ARCH=$(uname -m)
OS=$(uname -s | tr '[:upper:]' '[:lower:]')
SCREENS=1
SCREEN_SIZE="900x700"
DISPLAY_NUMBER=5

################################################################################
while getopts "dhns:" o; do
  case "${o}" in
    d) SCREEN_SIZE=$OPTARG
       ;;

    h) usage
       exit
       ;;

    n) DISPLAY_NUMBER=$OPTARG
       ;;

    s) SCREENS=$OPTARG
       ;;

    *) echo; usage
       exit 1
       ;;
  esac
done

shift $((OPTIND-1))

################################################################################
XMOBAR_CONFIG_DIR=$PWD/xmobar-config
XMONAD_CONFIG_DIR=$PWD/state/config
XMONAD_CACHE_DIR=$PWD/state/cache
XMONAD_DATA_DIR=$PWD/state/data
export XMOBAR_CONFIG_DIR XMONAD_CONFIG_DIR XMONAD_CACHE_DIR XMONAD_DATA_DIR

mkdir -p "$XMONAD_CONFIG_DIR" "$XMONAD_CACHE_DIR" "$XMONAD_DATA_DIR"

################################################################################
SCREEN_COUNTER=0
SCREEN_OPTS=""
X_OFFSET_CURRENT="0"
X_OFFSET_ADD=$(echo "$SCREEN_SIZE" | cut -dx -f1)

while expr "$SCREEN_COUNTER" "<" "$SCREENS"; do
  SCREEN_OPTS="$SCREEN_OPTS -origin ${X_OFFSET_CURRENT},0 -screen ${SCREEN_SIZE}+${X_OFFSET_CURRENT}"
  SCREEN_COUNTER=$(("$SCREEN_COUNTER" + 1))
  X_OFFSET_CURRENT=$(("$X_OFFSET_CURRENT" + "$X_OFFSET_ADD"))
done

ARCH_BIN=$XMONAD_DATA_DIR/xmonad-$ARCH-$OS
rm -f "$ARCH_BIN"
RAW_BIN=$(find "$PWD/dist-newstyle/" -type f -executable -name xmonad-testing)
# cp -p "$RAW_BIN" "$ARCH_BIN"

LOGFILE=/dev/null

(
  pushd $HOME >/dev/null
  # shellcheck disable=SC2086
  Xephyr $SCREEN_OPTS +xinerama +extension RANDR \
         -ac -br -reset -terminate -verbosity 10 \
         -fp $(xset q | grep -F 'Font Path:' -A 1 | tail -1) \
         -softCursor ":$DISPLAY_NUMBER" > "$LOGFILE" 2>&1 &
  popd >/dev/null

  export DISPLAY=":$DISPLAY_NUMBER"
  sleep 1

  cabal new-repl <<'EOF'
    :load config.hs
    main
EOF
)
