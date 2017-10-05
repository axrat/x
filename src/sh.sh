#!/bin/bash

##debug
if [ "$DEBUG" = "TRUE" ]; then
  log "ARGS:[$@]"
  log "ALIAS:[${XALIAS[@]}]"
#  for ((no = 0; no < ${#XALIAS[@]}; no++)) {
#    log "[$((no+1))]:${XALIAS[no]}"
#  }
fi

##main
if [ "$1" = "NULL" ]; then
cat << EOF
test,sqlite
EOF
else
  case "$1" in
"test" )  echo "test call";;
"env" )
ENV=$2
ENV_ARGS=${@:4:($#-1)}
if [[ $ENV = "bash" || $ENV = "node" ]]; then
  ENV_BIN="$PROFILE/env/$ENV"
  if [[ $# -ge 3 && -e "$ENV_BIN/$3" ]]; then
    /usr/bin/env $ENV $ENV_BIN/$3 ${ENV_ARGS[@]}
  else
    ls "$PROFILE/env/$ENV/"
  fi
else
  ls "$PROFILE/env"
fi
;;
"sqlite" )
DB="$BIN_DIR/mysqlite.db"
CMD="sqlite3 ${DB}"
if [ -e "${DB}" ]; then
    echo "${DB} is already exists"
else
    echo "CREATE TABLE tbl1(one varchar(10), two smallint);" | $CMD
    echo "insert into tbl1 values('hello!',10);" | $CMD
    echo "insert into tbl1 values('goodbye', 20);" | $CMD
    echo "create database ${DB}"
fi
echo "select * from tbl1;" | $CMD
;;
    * ) echo "unknown call : $1" ;;
  esac
fi
