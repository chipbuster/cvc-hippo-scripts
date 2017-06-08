#!/usr/bin/env bash

### Checks that the amount of storage used isn't running too low

source /net/cvcfs/storage/cvcfs-admin/scripts/config.sh

cd "$LOGDIR"
USEFILE=rawdiskusage.internal.txt   # Used for internal calculations
OUTFILE=diskusage.txt
WARN_PERCENT=80

# Find the size of each toplevel directory and store this information

## This step is currently being ignored because it takes way too damn long
## with some of the files we have stored here. May be introduced later on

# find "$STORDIR" -maxdepth 1 -type d \
# -exec du --bytes --summarize \{\} \; > "$USEFILE"

# Find total storage available on this volume
TOTAL_STORAGE=$(df --block-size=1 --output=size "$STORDIR" | tail -n 1)

# Find the storage used from the recorded disk usage data
# STORAGE_USED=$(grep "$STORDIR" "$USEFILE" | awk '{print $1}')
STORAGE_USED=$(df --block-size=1 --output=used "$STORDIR" | tail -n 1)
PERCENT_USED=$(echo "scale=5; 100 * $STORAGE_USED / $TOTAL_STORAGE" | bc)

# If storage is running low, do warnings
if [ 1 -eq $(echo "$PERCENT_USED > $WARN_PERCENT" | bc) ]; then 
  echo "SHITE!"
fi

echo "Done!"
