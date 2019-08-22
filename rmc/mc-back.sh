#!/bin/bash

## User provided Variables ##

# Server name is typically the name of the root minecraft server directory
TIME_ZONE=":US/Pacific"
SERVER_NAME=minecraft-1.12.2

# Backup Related Settings
EXCLUDE_FROM=/opt/etc/exclude.conf
PATH_FROM=/opt/minecraft
PATH_TO=/opt/minecraft

# Remote MC Server?
REMOTE_SERVER=false

# Remote Backup?
REMOTE_BACKUP=true

# if REMOTE_SERVER or REMOTE_BAKCUP = True these settings are enabled and used
# File transfers are rsynced using an SSH Connection
# REQUIRED: SSH keypair for unatended user access
REMOTE_USER=user
REMOTE_HOST=host.example.com
SSH_PORT=22

# Log file location for backup process
LOG_FILE=/var/log/mc-back.log

## SYSTEM VARIABLES DO NOT CHANGE ##
NOW=$(date +"%m-%d-%Y")

## Functions ##

function MCCommunicate()
{
    # Dont forget to set NAME or whatever
    if [ "$REMOTE_SERVER" = true ]; then
        ssh -p $SSH_PORT $REMOTE_USER@$REMOTE_HOST screen -S $SCREEN_NAME -p 0 -X stuff \"$1$(printf \\r)\"
    else
        screen -S $SERVER_NAME -p 0 -X stuff \"$1$(printf \\r)\"
    fi
}

## start  ##
echo "[$NOW $(date +"%H:%M")] Minecraft Backup started" >> $LOG_FILE
MCCommunicate "say [$(TZ=$TIME_ZONE date +"%H:%M") US-Pac] [$(uname -n)] Performing an incremental backup of the world."

# During sync delete removed files so our copy is identical to the master, also ignore logs and remove them from our local copy.
if [ "$REMOTE_BACKUP" = true ]; then
    rsync -avh --compress-level=10 --itemize-changes --sparse --delete-during --delete-excluded --exclude-from=$EXCLUDE_FROM -e "ssh -p $SSH_PORT" $REMOTE_USER@$REMOTE_HOST:$PATH_FROM/$SERVER_NAME/ $PATH_TO/$SERVER_NAME >> $LOG_FILE
else
    rsync -avh --compress-level=10 --itemize-changes --sparse --delete-during --delete-excluded --exclude-from=$EXCLUDE_FROM  $PATH_FROM/$SERVER_NAME/ $PATH_TO/$SERVER_NAME >> $LOG_FILE
fi
echo "[$NOW $(date +"%H:%M")] Minecraft systems synced" >> $LOG_FILE
MCCommunicate "say [$(TZ=$TIME_ZONE date +"%H:%M") US-Pac] [$(uname -n)] Systems synced."
