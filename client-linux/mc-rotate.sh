#!/bin/bash

## User provided Variables ##
REMOTE_USER=admiral
REMOTE_HOST=starfleetdelta.com
SSH_PORT=22
SCREEN_NAME=$2
LOG_FILE=/var/log/minecraft/mc-back.log
TIME_ZONE=":US/Pacific"

## SYSTEM VARIABLES DO NOT CHANGE ##
NOW=$(date +"%m-%d-%Y")

ssh -p $SSH_PORT $REMOTE_USER@$REMOTE_HOST screen -S $SCREEN_NAME -p 0 -X stuff \"say [§e$(TZ=$TIME_ZONE date +"%H:%M")§r] [§3$(uname -n)§r] $1$(printf \\r)\"
