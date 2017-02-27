#!/bin/bash

## User provided Variables ##
REMOTE_USER=user
REMOTE_HOST=host.name
SSH_PORT=22
SCREEN_NAME=mc_server_screen_name
LOG_FILE=/var/log/mc-back.log

## SYSTEM VARIABLES DO NOT CHANGE ##
NOW=$(date +"%m-%d-%Y")

## Functions ##

function MCCommunicate()
{
    # Dont forget to set NAME or whatever
    ssh -p $SSH_PORT $REMOTE_USER@$REMOTE_HOST screen -S $SCREEN_NAME -p 0 -X stuff \"$1$(printf \\r)\"
}

## start  ##
echo "[$NOW $(date +\"%H%M\")] Minecraft Backup started" >> $LOG_FILE
MCCommunicate "say [$(date +\"%H%M\") MST] [$(uname -n)] Performing an incremental backup of the world."

## Adds an --exclude for the dynmap folder >..< saves bandwidth as we have to re render the map on our side anyway
## this also cuts sync time to almost 1 minute ^_^
rsync -avzh -e "ssh -p $SSH_PORT" $REMOTE_USER@$REMOTE_HOST:/opt/minecraft /opt/

echo "[$NOW $(date +\"%H%M\")] Minecraft systems synced" >> $LOG_FILE
MCCommunicate "say [$(date +\"%H%M\") MST] [$(uname -n)] Systems synced."
