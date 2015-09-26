#!/bin/bash

## SSH TUNNEL ##
ssh -fN -l admiral -L 2222:192.168.15.8:22 uesfrp.no-ip.org

# logical path for the command above
# LOCAL 2222 ----> VALKERY -------> 22 NIMITZ
# LOCAL <----------------------------- RSYNC
# remote rsync destination: Local

## RSYNC TUNNEL ##
rsync -avzhe "ssh -p 2222" Admiral@localhost:/home/Admiral/ /srv/BACKUPS
rsync -avzhe "ssh -p 2222" Admiral@localhost:/var/www/ /srv/BACKUPS
rsync -avzhe "ssh -p 2222" Admiral@localhost:/opt/ /srv/BACKUPS

## RSYNC REMOTE ##
rsync -avzhe ssh admiral@uesfrp.no-ip.org:/opt/ /srv/BACKUPS
rsync -avzhe ssh admiral@uesfrp.no-ip.org:/home/admiral /srv/BACKUPS