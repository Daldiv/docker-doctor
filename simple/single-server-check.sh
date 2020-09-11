#!/bin/bash


########################################
### Server/Docker Diagnostics Script ###
########################################


#################
### Variables ###

# Time Stamp.
DAY=$(date +"%d-%y")
NOW=$(date +"%m-%d-%y")

# File Path.
PATH="/usr/bin/"
LOG="/home/entermedia/docker-doctor"

# Servers to SSH into.
SERVERS=("m45", "m46", "m47")

# Websites to Check.
SITES=("https://#SITE-REPLACE", "http://#REPLACE", "#SITE-REPLACE.com")

# Logging function.
if [ ! -d $LOG ]; then
	mkdir $LOG 
	mkdir $LOG/logs
	mkdir $LOG/logs/$DAY
fi

exec 3>&1 4>&2
trap 'exec 2>&4 1>&3' 0 1 2 3
exec 1>$LOG/$DAY/$NOW-run.log 2>&1

# Checks for folders on control server.
printf "$s\nChecking Working Folders$s\n$s\n"
if [ ! -d $PATH ]; then
        mkdir -v $PATH/
fi


###########################################
### Runs basic website check from local ###

for SITE in "${SITES[@]}"
do
	printf "$s\nChecking $SITE $s\n"

	# Uses curl to get response code.
	while true
	do
  		STATUS=$(curl -s -o /dev/null -w '%{http_code}' $SITE)
  		if [ $STATUS -eq 200 ]; then
    			echo "RESPONSE: $SITE HTTP 200"
    			break
  		else
    			echo "RESPONSE: $SITE HTTP $STATUS"
			bash $LOG/diagnostics.sh
  		fi
	done
done
	

################################################
### Runs same as above through SSH to remote ###

for SITE in "${SITES[@]}"
do
	for SERVER in "{SITES[@]}"
        printf "$s\nChecking $SITE $s\n"

        # Uses curl to get response code.
        while true
        do
                STATUS=$(curl -s -o /dev/null -w '%{http_code}' $SITE)
                if [ $STATUS -eq 200 ]; then
                        echo "RESPONSE: $SITE HTTP 200"
                        break
                else
                        echo "RESPONSE: $SITE HTTP $STATUS"
                        bash $LOG/diagnostics.sh
                fi
        done
done

