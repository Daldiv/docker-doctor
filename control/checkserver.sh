#!/bin/bash


################################################
### Docker Doctor Network Diagnostics Script ###

# Runs the actual script on $SERVER. It's faster.

# Server to SSH into.
SERVER="#REPLACE"

# URL for logging.
URL="#REPLACE.URL.com"

# File path for logs.
LOG="/home/$USER/docker-doctor/logs"

# Time Stamp.
DAY=$(date +"%d-%m")
NOW=$(date +"%T")

# Checks for directories.
if [ ! -d $LOG ]; then
        mkdir $LOG
fi
if [ ! -d $LOG/$DAY ]; then
        mkdir $LOG/$DAY
fi

# Creates log file.
touch $LOG/$DAY/$URL-$NOW-debug.log

# Runs SSH command to run diagnostics script.
ssh $SERVER "bash /home/$USER/docker-doctor/checkserver.sh" 2>&1 | tee $LOG/$DAY/$URL-$NOW-debug.log
printf "$s\n$s\n$s\nLogs@ $SERVER: Located@ $LOG $s\n$s\n"

