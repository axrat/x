#!/bin/bash
#[ "$DEBUG" = "TRUE" ] && \
	log "rc mode @:$@"
if [ ! "$ARGS" = "NULL" ]; then
  log "args is not null"
else
  log "args is null"
fi
