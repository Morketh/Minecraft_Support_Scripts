#!/bin/bash

## User provided Variables ##
REMOTE_USER=admiral
REMOTE_HOST=starfleetdelta.com
SSH_PORT=22
SCREEN_NAME=1-7-10_forge-1614
LOG_FILE=/var/log/mc-back.log
TIME_ZONE=":US/Pacific"
ModList=/opt/minecraft/forge-1614/mods/mod_list.txt
## SYSTEM VARIABLES DO NOT CHANGE ##
NOW=$(date +"%m-%d-%Y")

## Functions ##

# Dont forget to set NAME or whatever
echo "[$NOW] Starting 7z packup date"
ssh -p $SSH_PORT $REMOTE_USER@$REMOTE_HOST "rm /var/www/html/minecraft/CollectiveIndustriesMods.7z; cd  /opt/minecraft/forge-1614/mods; 7z a -t7z /var/www/html/minecraft/CollectiveIndustriesMods.7z  @"$ModList""
echo "[$NOW] Pack up date complete."
