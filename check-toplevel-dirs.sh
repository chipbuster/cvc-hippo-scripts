#!/usr/bin/env bash

### Checks that there are no unauthorized files at the top level

source /net/cvcfs/storage/cvcfs-admin/scripts/config.sh

cd "$LOGDIR"

# Parse the project-contacts file to get a list of good folders
declare -a AUTHORIZED_FILES

while read p; do
  if [[ $p == \#* ]]; then
    continue  # This is an instruction line
  elif [[ -z "${p// }" ]]; then
    continue  # This is an empty line
  else
    VALID_DIR=$(echo "$p" | awk '{print $1}')
    AUTHORIZED_FILES+=("$VALID_DIR")
  fi
done < "$STORDIR/project-contacts.txt"

# For debugging purposes
# echo ${AUTHORIZED_FILES[@]}

# Check each file found at the toplevel. If it's illegal, bark!
find /net/cvcfs/storage -maxdepth 1 -type d | while read RAWFNAME; do
    FILE_IS_LEGAL=false
    FNAME="$(basename "$RAWFNAME")"

    # Loop over all AUTHORIZED_FILES, checking for a match
    for LEGAL_NAME in "${AUTHORIZED_FILES[@]}"; do
        if [ "$FNAME" = "$LEGAL_NAME" ]; then
            FILE_IS_LEGAL=true
        fi
    done

    if [ "$FILE_IS_LEGAL" = false ]; then
        OWNER="$(check-owner "$RAWFNAME")"
        if [ "$OWNER" = "root" ]; then
          continue  # Root's stuff
        fi
        if [ $(looks-like-username "$OWNER") == "yes" ]; then
             ## Time to send mail!
            echo "ILLEGAL $RAWFNAME FROM $OWNER"
            EMAIL_ADDR="${OWNER}@ices.utexas.edu"
            SUBJECT="[CVC Watchdog]: Unlogged Toplevel Directories Present"

            ## Create a message
            MESSAGE_FILE="$TMPDIR/msg"
            rm -f "$MESSAGE_FILE"  # Clean
            cat "${MSGDIR}/unlogged-topdir.txt" > "$MESSAGE_FILE"
            echo "$RAWFNAME" >> "$MESSAGE_FILE"

            # Send the message
            mail -s "$SUBJECT" "$EMAIL_ADDR" < "$MESSAGE_FILE"
        fi
        echo "ILLEGAL FILE $RAWFNAME owned by $OWNER" >> $LOGFILE
    fi
done
