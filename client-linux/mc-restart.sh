#!/bin/bash

## User provided Variables ##
REMOTE_USER=admiral
REMOTE_HOST=starfleetdelta.com
SSH_PORT=22
SCREEN_NAME=1-7-10_forge-1614
LOG_FILE=/var/log/mc-back.log
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
MCCommunicate "say [$(TZ=$TIME_ZONE date +"%H:%M")] [$(uname -n)] Server restart in 10 minutes. Reason: $1"
sleep 5m # 5 minute warrnings.

MCCommunicate "say [$(TZ=$TIME_ZONE date +"%H:%M")] [$(uname -n)] Server restart in 5 minutes."

sleep 4m

MCCommunicate "say [$(TZ=$TIME_ZONE date +"%H:%M")] [$(uname -n)] Server restart in 1 minute. There will be no further warnings anyone left on the server will be kicked. Please allow 2 to 5 minutes for server startup."


sleep 1m

MCCommunicate "save-off"
MCCommunicate "save-all"
MCCommunicate "backup"

sleep 10s

# Once the backups and saves are done wait a little bit then kill the server and restart it
MCCommunicate "stop"

ssh -p $SSH_PORT $REMOTE_USER@$REMOTE_HOST "cd /opt/minecraft/forge-1614; ./mcstart.bash" >> $LOG_FILE
