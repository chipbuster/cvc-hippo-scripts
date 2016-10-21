# Configuration variables for CVCFS cleanup scripts

# Also contains a few small utility functions

export STORDIR="/net/cvcfs/storage"    # The location of the CVCFS Store
export OUTDIR="/net/cvcfs/storage/cvcfs-admin/output" # Location to log output
export TODAY="$(date +%F)"             # Today's date
export LOGDIR="$OUTDIR/$TODAY"         # Today's logs!
export TMPDIR="/tmp/cvcfsadmin"        # Place for temporary files
export MSGDIR="$STORDIR/cvcfs-admin/scripts/messages"  # Message stubs

# If the log directory for today's date doesn't exist, make it
if [ ! -d "$LOGDIR" ]; then
    mkdir "$LOGDIR"
fi

if [ ! -d "$TMPDIR" ]; then
    mkdir "$TMPDIR"
fi

function check-owner(){
    stat -c %U "$1"
}

function looks-like-username(){
    if [[ "$1" =~ ^[a-zA-Z]+[0-9]*$ ]]; then
        echo "yes"
    else
        echo "no"
    fi
}
