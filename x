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
declare -r ESRT="\e[37;40;5m"
declare -r EEND="\e[m"
declare -r SHARP="\e[33;40;5m#\e[m"
declare -r YEN="\e[33;40;1m$\e[m"
LINES=$(tput lines)
COLUMNS=$(tput cols)
INSTALL_DIR=$(cd $(dirname $BASH_SOURCE); pwd)
BIN_NAME=${BASH_SOURCE##*/}
BIN_DIR=$(dirname `readlink -f "$INSTALL_DIR/$BIN_NAME"`)
BIN_PATH="$BIN_DIR/$BIN_NAME"
SRC="$BIN_DIR/src"
export X=$BIN_PATH

##config
CONF="$SRC/conf.sh";
SH="$SRC/sh.sh"
RC="$SRC/rc.sh"
EX="$SRC/ex.sh"
declare -a IMPORT=("./default/import/*");
declare -a SCRIPT=("./default/script/example.sh");
declare -a ENV=("bash" "node");
declare -a MAKES=("sample ./default/Makefile");
declare -a XALIAS=();
ARGS=$@;
if [ "$DEBUG" = "TRUE" ]; then
  if [ $# -ge 1 ]; then
    ARGS=${ARGS#"-d"}
  fi 
fi
[ "$ARGS" = "" ] && ARGS="NULL"

##func
hr(){
  for no in `seq 1 $(tput cols)`; do 
    printf ${1:-"-"}
  done
}
hbr(){ hr && printf "\n"; }
ownlog(){ echo -e "$SHARP$ESRT $@$EEND"; }
log(){ echo -e "$YEN$ESRT $@$EEND"; }
notfound(){ log "==>NOT_FOUND:$@"; }
exist(){ [ -s "$1" ] && return 0 || return 1; }
check(){
  if exist "$1"; then
    [ "$DEBUG" = "TRUE" ] && log "==>CHECK:$1"
  else
    notfound $1;
  fi
}
load(){ 
  if exist "$1"; then
    [ "$DEBUG" = "TRUE" ] && log "==>LOAD:$1"
    \. "$1"
  else
    notfound $1;
  fi
}
dirload(){
FARY=();
for filepath in $1; do
  if [ -f $filepath ] ; then
    FARY+=("$filepath")
  fi
done
for item in ${FARY[@]}; do
  load $item
done
}

##debug
if [ "$DEBUG" = "TRUE" ]; then
  hbr
  ownlog "LINES:$LINES,COLUMNS:$COLUMNS"
  ownlog "\$#:$#,@:$@"
  ownlog "ARGS(\$@-d):$ARGS"
  ownlog "INSTALL:$INSTALL_DIR/$BIN_NAME"
  ownlog "BIN_PATH:$BIN_PATH"
  ownlog "SRC:$SRC"
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
  dirload $IMPORT_PATH
}

##script
for ((no = 0; no < ${#SCRIPT[@]}; no++)) {
  SCRIPT_PATH=${SCRIPT[no]/.\//$BIN_DIR/}
  check $SCRIPT_PATH
  XALIAS+=(${SCRIPT_PATH##*/})
}

##env
[ "$DEBUG" = "TRUE" ] && echo -e "$YEN$ESRT ENV:[${ENV[@]}]${EEND}"
for ((no = 0; no < ${#ENV[@]}; no++)) {
  XALIAS+=(${ENV[no]##*/})
}

##makes
for ((no = 0; no < ${#MAKES[@]}; no++)) {
  MAKE_PATH=${MAKES[no]/.\//$BIN_DIR/}
  if [ "$DEBUG" = "TRUE" ]; then
    log "MAKE.$((no+1)):[$MAKE_PATH]"
  fi
}
XALIAS+=("make")

[ "$DEBUG" = "TRUE" ] && hbr

##alias
if [ "$DEBUG" = "TRUE" ]; then
  echo -e "$YEN$ESRT XALIAS:[${XALIAS[@]}]${EEND}"
fi

##main
if [ "$SOURCE" = "TRUE" ]; then
  source ${RC/.\//$BIN_DIR/} $ARGS
else
  source ${SH/.\//$BIN_DIR/} $ARGS
fi

##ex
load $EX

##exit
[ "$DEBUG" = "TRUE" ] && hbr && printf "_COMPLETE_" && timestamp
if [ "$SOURCE" = "TRUE" ]; then
  return 0;
else
  exit 0;
fi
