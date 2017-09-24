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
ESRT="\e[37;40;5m"
EEND="\e[m"
LINES=$(tput lines)
COLUMNS=$(tput cols)
INSTALL_DIR=$(cd $(dirname $BASH_SOURCE); pwd)
BIN_NAME=${BASH_SOURCE##*/}
BIN_DIR=$(dirname `readlink -f "$INSTALL_DIR/$BIN_NAME"`)
BIN_PATH="$BIN_DIR/$BIN_NAME"
SRC="$BIN_DIR/src"

##config
CONF="./default/conf.sh";
SH="$SRC/sh.sh"
RC="$SRC/rc.sh"
EX="$SRC/ex.sh"
IMPORT=("./default/import/*");
SCRIPT=("./default/script/example.sh");
ENV=("bash");
MAKES=("sample ./default/Makefile");
XALIAS=();
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
log(){ echo -e "$ESRT$@$EEND"; }
logown(){ echo -e "\e[33;40m#\e[m${ESRT} ${@}${EEND}"; }
logusr(){ echo -e "\e[33;40;1m$\e[m${ESRT} ${@}${EEND}"; }
logf(){ [ $# -ne 2 ] && log "==> $1:${@:2:($#-1)}" || log $@; }
logng(){ echo -e "=====> \e[31;40;1m[$1]\e[m:${@:2:($#-1)}"; }
logok(){ echo -e "=====> \e[32;40;1m[$1]\e[m:${@:2:($#-1)}"; }
exist(){ [ -s "$1" ] && return 0 || return 1; }
check(){
  if exist "$1"; then
    [ "$DEBUG" = "TRUE" ] && logok "CHECK" $1
  else
    logng "NOT_FOUND" $1;
  fi
}
load(){ 
  if [ $# -ne 1 ]; then
    echo "Require [Path]"
  else
    if exist "$1"; then
      [ "$DEBUG" = "TRUE" ] && logok "LOAD" $1
      \. "$1"
    else
      notfound $1;
    fi
  fi
}
loadshdir(){
  if [ $# -ne 1 ]; then
    echo "Require [Path]"
  else
    FLIST=();
	for file in `\find $1 -maxdepth 1 -not -name '.*' -type f`; do
      FLIST+=("$file")
    done
  fi
  for target in ${FLIST[@]}; do
    load $target
  done
}

##export
export X=$BIN_PATH
export XD=$BIN_DIR
export RC
export SH
export EX

##debug
if [ "$DEBUG" = "TRUE" ]; then
  hbr
  logown "LINES:$LINES,COLUMNS:$COLUMNS"
  logown "\$#:$#,@:$@"
  logown "ARGS(\$@-d):$ARGS"
  logown "INSTALL:$INSTALL_DIR/$BIN_NAME"
  logown "BIN_PATH:$BIN_PATH"
  logown "SRC:$SRC"
fi

##override
CONF=${CONF/.\//$BIN_DIR/}
if [ -s "$CONF" ]; then
  [ "$DEBUG" = "TRUE" ] && logf "FindConfigurationScript:$CONF"
  \. "$CONF"
fi

[ "$DEBUG" = "TRUE" ] && hbr

if [ "$DEBUG" = "TRUE" ]; then
  logf "RC:$RC"
  logf "SH:$SH"
  check $EX
fi

##import
for ((no = 0; no < ${#IMPORT[@]}; no++)) {
  IMPORT_PATH=${IMPORT[no]}
  IMPORT_PATH=${IMPORT_PATH/.\//$BIN_DIR/}
  if [ "$DEBUG" = "TRUE" ]; then
    logusr "IMPORT.$((no+1)):$IMPORT_PATH"
  fi
  loadshdir $IMPORT_PATH
}

##script
for ((no = 0; no < ${#SCRIPT[@]}; no++)) {
  SCRIPT_PATH=${SCRIPT[no]/.\//$BIN_DIR/}
  [ "$DEBUG" = "TRUE" ] && logusr "SCRIPT.$((no+1)):"
  check $SCRIPT_PATH
  XALIAS+=("SCRIPT#${SCRIPT_PATH##*/}")
}

##env
[ "$DEBUG" = "TRUE" ] && logusr "ENV:[${ENV[@]}]"
for ((no = 0; no < ${#ENV[@]}; no++)) {
  XALIAS+=("ENV#${ENV[no]##*/}")
}

##makes
for ((no = 0; no < ${#MAKES[@]}; no++)) {
  MAKE_PATH=${MAKES[no]/.\//$BIN_DIR/}
  if [ "$DEBUG" = "TRUE" ]; then
    logusr "MAKE.$((no+1)):[$MAKE_PATH]"
  fi
  XALIAS+=("MAKE#")
}

##alias
if [ "$DEBUG" = "TRUE" ]; then
  logusr "XALIAS"
  #logf "XALIAS:[${XALIAS[@]}]${EEND}"
  for ((no = 0; no < ${#XALIAS[@]}; no++)) {
    logok "No.$((no+1))" "${XALIAS[no]}"
  }
fi

[ "$DEBUG" = "TRUE" ] && hbr

##main
if [ "$SOURCE" = "TRUE" ]; then
  source ${RC/.\//$BIN_DIR/} $ARGS
else
  source ${SH/.\//$BIN_DIR/} $ARGS
fi

##exit
[ "$DEBUG" = "TRUE" ] && hbr && printf "_COMPLETE_" && timestamp
if [ "$SOURCE" = "TRUE" ]; then
  return 0;
else
  ##ex
  load $EX
  exit 0;
fi
