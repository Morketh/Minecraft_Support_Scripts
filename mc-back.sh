#!/bin/bash

## User provided Variables ##
BNAME="CI_[1-7-10]_Cauldron_1-1207-01-198"
REMOTE_USER=admiral
REMOTE_HOST=uesfrp.no-ip.org

## this will provide the world name to the the dynmap engine for a full render
MAP_NAME=CI_LVL_3

## SYSTEM VARIABLES DO NOT CHANGE ##
NOW=$(date +"%m-%d-%Y")
FILE="$BNAME.$(date +"%m-%d-%Y").tar.gz"
LOG_FILE=/var/log/mc-back.log

### MODE PULL ###

## start  ##
echo "[$(date +"%m-%d-%Y") $(date +"%H%M")] Minecraft Backup started" >> $LOG_FILE
screen -p 0 -S SCREEN_Cauldron_1-7-10 -X stuff "say $(date +"%H%M") [$(uname -n)] SERVER is preforming an incremental backup of $REMOTE_HOST. LOCAL server shutting down in 30 seconds$(printf \\r)"
sleep 30
screen -p 0 -S SCREEN_Cauldron_1-7-10 -X stuff "stop$(printf \\r)"

MCPID=$(ps aux | grep [S]CREEN_Cauldron_1-7-10 | awk '{print $2}')
echo "[$(date +"%m-%d-%Y") $(date +"%H%M")] waiting for $MCPID to finish......" >> $LOG_FILE
ssh $REMOTE_USER@$REMOTE_HOST "screen -p 0 -S Cauldron_1-7-10 -X stuff 'say $(date +"%H%M") MST [$(uname -n)] Systems are preparing for full sync $(uname -n) is going down.$(printf \\r)'"

while [[ -n $(ps aux | grep [S]CREEN_Cauldron_1-7-10 | awk '{print $2}') ]]
do
true ## Stupid loop can NOT be empty >..<
done
echo "[$(date +"%m-%d-%Y") $(date +"%H%M")] Server PID $MCPID died.. running backup" >> $LOG_FILE

ssh $REMOTE_USER@$REMOTE_HOST "screen -p 0 -S Cauldron_1-7-10 -X stuff 'say $(date +"%H%M") MST [$(uname -n)] preforming an incremental backup of the world please stand-by$(printf \\r)'"
## Adds an --exclude for the dynmap folder >..< saves bandwidth as we have to re render the map on our side anyway
## this also cuts sync time to almost 1 minute ^_^
rsync -avzhe ssh --exclude 'dynmap/*' $REMOTE_USER@$REMOTE_HOST:/opt/Cauldron_1-7-10_1-1207-01-198 /opt

echo "[$(date +"%m-%d-%Y") $(date +"%H%M")] Minecraft systems synced" >> $LOG_FILE
ssh $REMOTE_USER@$REMOTE_HOST "screen -p 0 -S Cauldron_1-7-10 -X stuff 'say $(date +"%H%M") MST [$(uname -n)] Systems Synced. $(uname -n) restarting.$(printf \\r)'"
## turn local MC back online ##
screen -d -m -S SCREEN_Cauldron_1-7-10 bash -c 'java -Xmx2G -Xms1G -XX:MaxPermSize=1024m -XX:+CMSClassUnloadingEnabled -jar cauldron-1.7.10-1.1207.01.198-server.jar'

## Send full render to the server
screen -p 0 -S SCREEN_Cauldron_1-7-10 -X stuff "dynmap fullrender $MAP_NAME$(printf \\r)"

### MODE PUSH ###
## TODO add in code to push a local copy out to the remote host
## code should be very similar to the above with the exception of shutting the remote host's screen and pushing local copy to the remote host