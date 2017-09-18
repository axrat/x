#!/bin/bash
#[ "$DEBUG" = "TRUE" ] && \
	log "sh mode @:$@"
if [ ! "$ARGS" = "NULL" ]; then
  log "args is not null"
else
  log "args is null"
fi
