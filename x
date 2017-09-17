#!/bin/bash


##flg
[[ "$1" =~ ^-d$ ]] && DEBUG="TRUE" || unset DEBUG
[ "$DEBUG" = "TRUE" ] && echo "#DEBUG_MODE" \
#	|| echo "#NOT_DEBUG_MODE"
if echo "$-" | grep -q "i"; then
  SOURCE="TRUE"
fi

##var
LINES=$(tput lines)
COLUMNS=$(tput cols)
SH="./src/sh.sh"
RC="./src/rc.sh"
ARGS=$@
if [ "$DEBUG" = "TRUE" ]; then
  if [ $# -ge 1 ]; then
    ARGS=${ARGS#"-d"}
  fi 
fi

##func
hr(){
  for i in `seq 1 $(tput cols)`; do 
    printf ${1:-"-"}
  done
}
hbr(){ hr && printf "\n"; }

##init
#BASENAME=`basename $0`
#INSTALL_DIR=$(cd $(dirname $BASH_SOURCE); pwd)
#BIN_PATH=$(readlink -f "$INSTALL_DIR/$BASENAME")

##debug
if [ "$DEBUG" = "TRUE" ]; then
  echo "#LINES:$LINES,COLUMNS:$COLUMNS"
  echo "#\$#:$#,@:$@"
  printf "#ARGS(\$@-d):" && [ "$ARGS" = "" ] && echo "null" || echo $ARGS
#  if [ ! "$SOURCE" = "TRUE" ]; then
#  echo "#INSTALL:$INSTALL_DIR/$BASENAME"
#  echo "#BIN_PATH:$BIN_PATH"
#  fi
  hbr
fi

##main
if [ "$SOURCE" = "TRUE" ]; then
  source $RC $ARGS
else
  source $SH $ARGS
fi

##exit
[ "$DEBUG" = "TRUE" ] && hbr
if [ "$SOURCE" = "TRUE" ]; then
  return 0;
else
  exit 0;
fi
