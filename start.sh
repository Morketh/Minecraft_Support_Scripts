#!/bin/bash
screen -d -m -S Cauldron_1-7-10 bash -c 'java -Xmx10G -Xms1G -jar -XX:MaxPermSize=1024m -XX:+CMSClassUnloadingEnabled cauldron-1.7.10-1.1207.01.198-server.jar'