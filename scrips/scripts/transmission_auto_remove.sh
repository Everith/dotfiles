#!/bin/sh

# Automatically remove a torrent and delete its data after a specified period of
# time (in seconds).

TARGET=This is where you put your completed torrents.
USER=erik
PASS=erik
BIN="/usr/bin/transmission-remote"

# The default is 10 days (in seconds).
CUTOFF=`expr 86400 \* 20`

##############################################
### You shouldn't need to edit below here. ###
##############################################

# Tokenise over newlines instead of spaces.
OLDIFS=$IFS
IFS="
"

for ENTRY in `$BIN -n $USER:$PASS -l | grep 100%.*Done.*Finished`; do

    # Pull the ID out of the listing.
    ID=`echo $ENTRY | sed "s/^ *//g" | sed "s/ *100%.*//g"`

    # Determine the name of the downloaded file/folder.
    NAME=`$BIN -n $USER:$PASS -t $ID -f | head -1 |\
         sed "s/ ([0-9]\+ files)://g"`

    # If it's a folder, find the last modified file and its modification time.
    if [ -d "$TARGET/$NAME" ]; then
        LASTMODIFIED=0
        for FILE in `find $TARGET/$NAME`; do
             AGE=`stat "$FILE" -c%Y`
             if [ $AGE -gt $LASTMODIFIED ]; then
                 LASTMODIFIED=$AGE
             fi
        done

    # Otherwise, just get the modified time.
    else
        LASTMODIFIED=`stat "$TARGET/$NAME" -c%Y`
    fi

    TIME=`date +%s`
    DIFF=`expr $TIME - $LASTMODIFIED`

    # Remove the torrent if its older than the CUTOFF.
    if [ $DIFF -gt $CUTOFF ]; then
        date
        echo "Removing $NAME with ID:$ID"
        $BIN -n $USER:$PASS -t $ID --remove-and-delete
    fi

done

IFS=$OLDIFS
