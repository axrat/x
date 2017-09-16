#!/usr/bin/env bash
if [ -z "${LOCAL_BIN+x}" ] ; then
 echo "require \$LOCAL_BIN"
 exit
fi
NAME=x
INSTALL=$LOCAL_BIN/$NAME
rm -f $INSTALL
ln -s $(pwd)/$NAME $INSTALL

echo "complate"
