#!/bin/bash


######################################
##### Network Diagnostics Script #####
######################################


# Runs several commands to gather networking and Docker data based on the 5 layer TCP/IP model outputting a txt file.


#################
### Variables ###

# URL passed from Prometheus.
#URL="$1"
URL="#REPLACE"
URLLOG="#REPLACE"

# Docker container name.
#CONTAINER="$2"
CONTAINER="#REPLACE"

# Local default gateway.
SERVER="#REPLACE"

# Time Stamp.
DAY=$(date +"%d-%m")
NOW=$(date +"%T")

# File Paths.
PAT="/sbin"
LOG="/home/$USER/docker-doctor/logs"

# Local network interfaces.
ETH0="#REPLACE"
#ETH1="#REPLACE"
DOCKER="docker0"


########################
### Logging Function ###

# Checks for directories
if [ ! -d $LOG ]; then
        mkdir $LOG
fi
if [ ! -d $LOG/$DAY ]; then
        mkdir $LOG/$DAY
fi

# Creates log file.
touch $LOG/$DAY/$URLLOG-$NOW-debug.log

# Logs all output to file.
exec 3>&1 4>&2
trap 'exec 2>&4 1>&3' 0 1 2 3
exec 1> $LOG/$DAY/$URLLOG-$NOW-debug.log 2>&1


###############
### Network ###

# All network interfaces.
printf "$s\nIP Link Output:$s\n$s\n"
$PAT/ip -br link show
$PAT/ip route
nmcli device

# Detailed in use network interfaces.
$PAT/ip -s link show $ETH0
#$PAT/ip -s link show $ETH1
$PAT/ip -s link show $DOCKER

# Hardware ethernet.
printf "$s\n$s\nEthtool Output:$s\n$s\n"
$PAT/ethtool $ETH0
#$PAT/ethtool $ETH1
nmcli device show $ETH0
#nmcli device show $ETH1

# ARP resolution.
printf "$s\n$s\nARP Resolution:$s\n$s\n"
$PAT/ip neighbor show
$PAT/arp -an

# IP address & external internet.
printf "$s\n$s\nLayer 3 Output:$s\n$s\n"
$PAT/ip -br address show
$PAT/ip route show

# DNS resolution.
printf "$s\n$s\nDNS Resolution:$s\n$s\n"
nslookup $URL
cat /etc/hosts

# TCP ports.
printf "$s\n$s\nTCP Port Output:$s\n$s\n"
$PAT/ss -tunlsp4
netstat -atuvn -ee >>$LOG/$DAY/netstat-$URLLOG-$NOW-.log
cat $LOG/$DAY/netstat-$URLLOG-$NOW-.log

# Netstat summary.
printf "$s\n$s\nNetstat Output:$s\n$s\n"
netstat -i
netstat -l
netstat -s

# IP tables capture.
printf "$s\n$s\nIPtables Rules Capture:$s\n$s\n"
sudo $PAT/iptables -L

# Connectivity.
printf "$s\n$s\nConnectivity Output:$s\n$s\n"
ping -c 2 $SERVER
ping -c 2 $URL
traceroute $URL
printf "$s\nCurl Output:$s\n"
curl $URL


##############
### Docker ###

# Inspects Container.
printf "$s\n$s\nDOCKER INSPECT:$s\n$s\n"
sudo docker inspect $CONTAINER


###############
### TCPDUMP ###

#sudo tcpdump -vvv -c 100 -A -d -n -i docker0
#sudo nohup tcpdump -c 100 
