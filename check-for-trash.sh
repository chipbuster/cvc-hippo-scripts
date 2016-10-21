#!/usr/bin/env bash

### Checks that there are no trash directories present

source config.sh

cd "$LOGDIR"



# Find the directories at the top of the tree and check if they are trash
find /net/cvcfs/storage -type d | while read FNAME; do
  BASEFNAME=$(basename $FNAME)
  
  if [[ "$BASEFNAME" =~ ^\.Trash\-[0-9]+ ]]; then
    OWNER="$(check-owner "$FNAME")"
    echo "Found trash belonging to $OWNER"
  fi

done
