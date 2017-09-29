#!/bin/bash

##debug
if [ "$DEBUG" = "TRUE" ]; then
  log "ARGS:[$@]"
  log "ALIAS:[${XALIAS[@]}]"
#  for ((no = 0; no < ${#XALIAS[@]}; no++)) {
#    log "[$((no+1))]:${XALIAS[no]}"
#  }
fi

##readme
function xreadme(){
cat << EOF
test,sqlite
EOF
}

##main
if [ "$ARGS" = "NULL" ]; then
  xreadme
else
  case $1 in

"test" )  echo "test call";;

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
