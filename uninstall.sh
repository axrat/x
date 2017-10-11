#!/usr/bin/env bash
if [ -z "${BIN+x}" ] ; then
 echo "require env \$BIN"
 exit
fi
NAME=x
INSTALL=$BIN/$NAME
rm -f $INSTALL

echo "complate"
