#!/bin/bash
screen -d -m -S SCREEN_PixelmonTrains_1.12.2 bash -c 'java -Xmx7518M -Xms1G -jar -XX:MaxPermSize=1024m -XX:+CMSClassUnloadingEnabled -jar forge-1.12.2-14.23.5.2838-universal.jar nogui'
