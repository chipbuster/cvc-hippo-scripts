#!/usr/bin/env bash

### Checks that there are no unauthorized files at the top level

source config.sh

cd "$LOGDIR"

# List of files that are supposed to be in the toplevel
AUTHORIZED_FILES=("project-contacts.md" "README.md" "VIEW_README_BEFORE_USING_CVCFS")

# Check each file found at the toplevel. If it's illegal, bark!
find /net/cvcfs/storage -maxdepth 1 -type f | while read RAWFNAME; do
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
        if [ $(looks-like-username "$OWNER") == "yes" ]; then
            ## Time to send mail!
            EMAIL_ADDR="${OWNER}@ices.utexas.edu"
            SUBJECT="[CVC Watchdog]: Trash Files Present"

            ## Create a message by sedding stuff
            MESSAGE_FILE="$TMPDIR/msg"
            cat "${MSGDIR}/toplevel.txt" > "$MESSAGE_FILE"
            echo "$RAWFNAME" >> "$MESSAGE_FILE"

            mail -s "$SUBJECT" "$EMAIL_ADDR" < "$MESSAGE_FILE"

            echo "Trash file $BASEFNAME from owner $OWNER"
        fi
        echo "ILLEGAL FILE $RAWFNAME owned by $OWNER"
    fi
done
