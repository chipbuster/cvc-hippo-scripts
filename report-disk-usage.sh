#!/usr/bin/env bash

### Checks that the amount of storage used isn't running too low

source config.sh

cd "$LOGDIR"
USEFILE=rawdiskusage.internal.txt   # Used for internal calculations
OUTFILE=diskusage.txt

# Find the size of each toplevel directory and store this information
find "$STORDIR" -maxdepth 1 -type d \
-exec du --bytes --summarize \{\} \; > "$USEFILE"

# Find total storage available on this volume
TOTAL_STORAGE=$(df --block-size=1 --output=size "$STORDIR")

# Find the storage used from the recorded disk usage data
STORAGE_USED=$(grep "$STORDIR" "$USEFILE" | awk '{print $1}')


