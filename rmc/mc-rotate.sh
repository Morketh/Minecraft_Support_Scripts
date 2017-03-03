#!/bin/bash

## User provided Variables ##
REMOTE_USER=user
REMOTE_HOST=host
SSH_PORT=22
SCREEN_NAME=1-7-10_forge
LOG_FILE=/var/log/mc-back.log
TIME_ZONE=":US/Pacific"

## SYSTEM VARIABLES DO NOT CHANGE ##
NOW=$(date +"%m-%d-%Y")

ssh -p $SSH_PORT $REMOTE_USER@$REMOTE_HOST screen -S $SCREEN_NAME -p 0 -X stuff \"say [$(TZ=$TIME_ZONE date +"%H:%M")] [$(uname -n)] $1$(printf \\r)\"
