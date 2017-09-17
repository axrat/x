#!/bin/bash

##flg
timestamp(){ printf " : %.23s\n" "$(date +'%Y-%m-%d %H:%M:%S.%N')"; }
[[ "$1" =~ ^-d$ ]] && DEBUG="TRUE" || unset DEBUG
[ "$DEBUG" = "TRUE" ] && printf "DEBUG_MODE" && timestamp \
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
CONF="$BIN_DIR/src/conf.sh"
declare -a IMPORT=("./src/import")
declare -a ENV=("bash" "node")
declare -a SCRIPT=("./src/script")
declare -a MAKES=("sample ./default/Makefile")
ARGS=$@
if [ "$DEBUG" = "TRUE" ]; then
  if [ $# -ge 1 ]; then
    ARGS=${ARGS#"-d"}
  fi 
fi
[ "$ARGS" = "" ] && ARGS="null"

##func
hr(){
  for no in `seq 1 $(tput cols)`; do 
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

[ "$DEBUG" = "TRUE" ] && hbr

##override
[ -s "$CONF" ] && \. "$CONF"

##import
for ((no = 0; no < ${#IMPORT[@]}; no++)) {
  IMPORT_PATH=${IMPORT[no]/.\//$BIN_DIR/}
  if [ "$DEBUG" = "TRUE" ]; then
    log "IMPORT.$((no+1)):$IMPORT_PATH"
  fi
}
##script
for ((no = 0; no < ${#SCRIPT[@]}; no++)) {
  SCRIPT_PATH=${SCRIPT[no]/.\//$BIN_DIR/}
  if [ "$DEBUG" = "TRUE" ]; then
    log "SCRIPT.$((no+1)):$SCRIPT_PATH"
  fi
}
##env
for ((no = 0; no < ${#ENV[@]}; no++)) {
  ENV_PATH=${ENV[no]/.\//$BIN_DIR/}
  if [ "$DEBUG" = "TRUE" ]; then
    log "ENV.$((no+1)):$ENV_PATH"
  fi
}
##makes
for ((no = 0; no < ${#MAKES[@]}; no++)) {
  MAKE_PATH=${MAKES[no]/.\//$BIN_DIR/}
  if [ "$DEBUG" = "TRUE" ]; then
    log "MAKE.$((no+1)):$MAKE_PATH"
  fi
}


##main
if [ "$SOURCE" = "TRUE" ]; then
  source ${RC/.\//$BIN_DIR/} $ARGS
else
  for ((no = 0; no < ${#SRC[@]}; no++)) {
    SRC_PATH=${SRC[no]/.\//$BIN_DIR/}
    if [ "$DEBUG" = "TRUE" ]; then
      log "SRC.$((no+1)):$SRC_PATH"
	fi
  }
  source ${SH/.\//$BIN_DIR/} $ARGS
fi

##exit
[ "$DEBUG" = "TRUE" ] && hbr && printf "_COMPLETE_" && timestamp
if [ "$SOURCE" = "TRUE" ]; then
  return 0;
else
  exit 0;
fi
