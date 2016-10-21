#!/usr/bin/env bash

### Checks that there are no trash directories present

source /net/cvcfs/storage/cvcfs-admin/scripts/config.sh

cd "$LOGDIR"

# Find the directories at the top of the tree and check if they are trash
find /net/cvcfs/storage -type d | while read FNAME; do
    BASEFNAME="$(basename "$FNAME")"

    # If the pattern matches that of a .Trash file, try to mail the owner
    if [[ "$BASEFNAME" =~ ^\.Trash\-[0-9]+ ]]; then
        OWNER="$(check-owner "$FNAME")"
        if [ $(looks-like-username "$OWNER") == "yes" ]; then
            ## Time to send mail!
            EMAIL_ADDR="${OWNER}@ices.utexas.edu"
            SUBJECT="[CVC Watchdog]: Trash Files Present"

            ## Create a message by sedding stuff
            MESSAGE_FILE="$TMPDIR/msg"
            rm -f "$MESSAGE_FILE"
            cat "${MSGDIR}/have-trash.txt" > "$MESSAGE_FILE"
            echo "$FNAME" >> "$MESSAGE_FILE"
            cat "${MSGDIR}/have-trash-2.txt" >> "$MESSAGE_FILE"

            mail -s "$SUBJECT" "$EMAIL_ADDR" < "$MESSAGE_FILE"

            echo "Trash file $BASEFNAME from owner $OWNER"
        fi
    fi

done
