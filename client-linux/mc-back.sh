#!/bin/bash

## User provided Variables ##
REMOTE_USER=admiral
REMOTE_HOST=starfleetdelta.com
SSH_PORT=22
SCREEN_NAME=$1
#SCREEN_NAME=1-7-10_forge
#SCREEN_NAME2=1-10-2_forge

LOG_FILE=/var/log/minecraft/mc-back.log
EXCLUDE_FROM=/opt/etc/exclude.conf
TIME_ZONE=":US/Pacific"

## SYSTEM VARIABLES DO NOT CHANGE ##
NOW=$(date +"%m-%d-%Y")

## Functions ##

function MCCommunicate()
{
    # Dont forget to set NAME or whatever
    ssh -p $SSH_PORT $REMOTE_USER@$REMOTE_HOST screen -S $SCREEN_NAME -p 0 -X stuff \"$1$(printf \\r)\"
}

## start  ##
echo "[$NOW $(date +"%H:%M")] Minecraft Backup started" >> $LOG_FILE
MCCommunicate "say [§e$(TZ=$TIME_ZONE date +"%H:%M")§r] [§3$(uname -n)§r] Performing an incremental backup of the world."

# During sync delete removed files so our copy is identical to the master, also ignore logs and remove them from our local copy.
rsync -avzh --delete-during --delete-excluded --exclude-from=$EXCLUDE_FROM -e "ssh -p $SSH_PORT" $REMOTE_USER@$REMOTE_HOST:/opt/minecraft /opt/ >> $LOG_FILE

echo "[$NOW $(date +"%H:%M")] Minecraft systems synced" >> $LOG_FILE
MCCommunicate "say [§e$(TZ=$TIME_ZONE date +"%H:%M")§r] [§3$(uname -n)§r] Systems synced."
