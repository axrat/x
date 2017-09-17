#!/bin/bash


##flg
[[ "$1" =~ ^-d$ ]] && DEBUG="TRUE" || unset DEBUG
[ "$DEBUG" = "TRUE" ] && printf "DEBUG_MODE\n" \
#	|| echo "#NOT_DEBUG_MODE"
if $(echo "$-" | grep -q "i"); then
  SOURCE="TRUE"
else
  unset SOURCE
fi

##var
LINES=$(tput lines)
COLUMNS=$(tput cols)
INSTALL_DIR=$(cd $(dirname $BASH_SOURCE); pwd)
BIN_NAME=${BASH_SOURCE##*/}
BIN_DIR=$(dirname `readlink -f "$INSTALL_DIR/$BIN_NAME"`)
SH="./src/default/sh.sh"
RC="./src/default/rc.sh"
CONF="./src/conf.sh"
declare -a SRC=("./src/default" "./src/env")
ARGS=$@
if [ "$DEBUG" = "TRUE" ]; then
  if [ $# -ge 1 ]; then
    ARGS=${ARGS#"-d"}
  fi 
fi
[ "$ARGS" = "" ] && ARGS="null"

##func
hr(){
  for i in `seq 1 $(tput cols)`; do 
    printf ${1:-"-"}
  done
}
hbr(){ hr && printf "\n"; }
ownlog(){ echo -e "\e[33;40;5m# \e[m\e[37;40;5m$@\e[m"; }
log(){ echo -e "\e[33;40;1m$ \e[m\e[37;40;5m$@\e[m"; }

##debug
if [ "$DEBUG" = "TRUE" ]; then
  hbr
  ownlog "LINES:$LINES,COLUMNS:$COLUMNS"
  ownlog "\$#:$#,@:$@"
  ownlog "ARGS(\$@-d):$ARGS"
  ownlog "INSTALL:$INSTALL_DIR/$BIN_NAME"
  ownlog "BIN_PATH:$BIN_DIR/$BIN_NAME"
fi

##override
[ -s "$CONF" ] && \. "$CONF"

#[ "$DEBUG" = "TRUE" ] && hbr

##main
if [ "$SOURCE" = "TRUE" ]; then
  source ${RC/.\//$BIN_DIR/} $ARGS
else
  for ((i = 0; i < ${#SRC[@]}; i++)) {
    SRC_PATH=${SRC[i]/.\//$BIN_DIR/}
    if [ "$DEBUG" = "TRUE" ]; then
      log "No.$((i+1)):$SRC_PATH"
	fi
  }
  source ${SH/.\//$BIN_DIR/} $ARGS
fi

##exit
[ "$DEBUG" = "TRUE" ] && hbr
if [ "$SOURCE" = "TRUE" ]; then
  return 0;
else
  exit 0;
fi
