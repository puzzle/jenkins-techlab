#!/bin/sh

sed -e "s/COWRIE_HOSTNAME/$COWRIE_HOSTNAME/g" -e "s/COWRIE_DOWNLOAD_SIZE_LIMIT/$COWRIE_DOWNLOAD_SIZE_LIMIT/g" /home/cowrie/cowrie/cowrie.cfg.skel > /home/cowrie/cowrie/cowrie.cfg
rm -rf /home/cowrie/cowrie/cowrie.pid
cd /home/cowrie/cowrie/ && /usr/bin/twistd -n --logfile=log/cowrie.log --pidfile=cowrie.pid cowrie
