#!/bin/bash
LOG_FILE=/var/log/minecraft/server.log
MAX_MEMORY=10G
MIN_MEMORY=2G
MAX_PERM_SIZE=4G

TIME_ZONE=":US/Pacific"

## System variables DO NOT EDIT ##
JAR=forge-1.7.10-10.13.4.1566-1.7.10-universal.jar
NOW=$(date +"%m-%d-%Y %H:%M")
PID=$(cat server.pid)

# wait for server to stop (if exists) then start it
# Dump output to dev null we dont need it.
while kill -0 $PID &> /dev/null
do
  true # just loop untill dead
done

echo "[$NOW] Minecraft Server stopped... Checking for newer release of forge essentials." >> $LOG_FILE

# Redirect output to log file.
wget -N http://files.forgeessentials.com/forgeessentials-1.7.10-server.jar -P mods/ 2>> $LOG_FILE
echo "[$NOW] Forge Essentials is upto date." >> $LOG_FILE


echo "[$NOW] Minecraft server sarting up." >> $LOG_FILE

# Load the screen use the configuration file inorder to load some defualt values.
screen -c config/screen.cfg -d -m -L -S 1-7-10_forge bash -c "java -Xmx$MAX_MEMORY -Xms$MIN_MEMORY -jar -XX:MaxPermSize=$MAX_PERM_SIZE -XX:+CMSClassUnloadingEnabled $JAR nogui"&

echo $! > server.pid
echo "[$NOW] Minecraft Server started with PID $!" >> $LOG_FILE