#!/bin/bash

## User provided Variables ##

# Server name is typically the name of the root minecraft server directory
TIME_ZONE=":US/Pacific"
SERVER_NAME=minecraft-1.12.2

# Remote MC Server?
REMOTE_SERVER=false

# if REMOTE_SERVER = True these settings are enabled and used
# REQUIRED: SSH keypair for unatended user access
REMOTE_USER=user
REMOTE_HOST=host.example.com
SSH_PORT=22

## SYSTEM VARIABLES DO NOT CHANGE ##
NOW=$(date +"%m-%d-%Y")
PID=$(cat server.pid)

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

function MCReboot()
{
    if [ "$REMOTE_SERVER" = true ]; then
        ssh -p $SSH_PORT $REMOTE_USER@$REMOTE_HOST screen -S $SCREEN_NAME -p 0 -X stuff \"$1$(printf \\r)\"
    else
        screen -S $SERVER_NAME -p 0 -X stuff \"$1$(printf \\r)\"
    fi
}

## start  ##
MCCommunicate "say [$(TZ=$TIME_ZONE date +"%H:%M")] [$(uname -n)] Server restart in 10 minutes. Reason: $1"
sleep 5m # 5 minute warrnings.

MCCommunicate "say [$(TZ=$TIME_ZONE date +"%H:%M")] [$(uname -n)] Server restart in 5 minutes. Reason: $1"

sleep 4m

MCCommunicate "say [$(TZ=$TIME_ZONE date +"%H:%M")] [$(uname -n)] Server restart in 1 minute. There will be no further warnings anyone left on the server will be kicked. Please allow 2 to 5 minutes for server startup."

sleep 1m

MCCommunicate "save-all"
MCCommunicate "backup"

sleep 30s

MCCommunicate "stop"
