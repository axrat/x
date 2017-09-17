#!/bin/bash

##var
LINES=$(tput lines)
COLUMNS=$(tput cols)
BASENAME=`basename $0`
INSTALL_DIR=$(cd $(dirname $BASH_SOURCE); pwd)
BIN_PATH=$(readlink -f "$INSTALL_DIR/$BASENAME")
##func
hr(){
  CHAR=${1:-"-"}
  for i in `seq 1 $(tput cols)`
  do
    printf "${CHAR}";
  done
}
##args
while getopts dv: OPT
do
  case $OPT in
    "d" ) DEBUG="TRUE" ;;
    "v" ) FLG_V="TRUE" ; VALUE_B="$OPTARG" ;;
#      * ) echo "Usage: $CMDNAME [-d] [-v VALUE]" 1>&2
#          exit 1 ;;
  esac
done
[ "$DEBUG" = "TRUE" ] && echo "DEBUG_MODE" \
#	|| echo "NOT_DEBUG_MODE"
if [ "$FLG_V" = "TRUE" ]; then
  echo '"-v"オプションが指定されました。 '
  echo "→値は$VALUE_Vです。"
fi
if [ "$DEBUG" = "TRUE" ]; then
  echo "LINES:$LINES,COLUMNS:$COLUMNS"
  echo "INSTALL:$INSTALL_DIR/$BASENAME"
  echo "BIN_PATH:$BIN_PATH"
  echo "ARGS(\$@):$@"
fi

exit 0
