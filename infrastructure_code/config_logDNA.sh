#!/bin/bash
echo "deb https://repo.logdna.com stable main" | sudo tee /etc/apt/sources.list.d/logdna.list 
wget -O- https://repo.logdna.com/logdna.gpg | sudo apt-key add - 
sudo apt-get update
sudo apt-get install logdna-agent < "/dev/null"
sudo logdna-agent -k $1
sudo logdna-agent -s LOGDNA_APIHOST=api.$REGION.logging.cloud.ibm.com
sudo logdna-agent -s LOGDNA_LOGHOST=logs.$REGION.logging.cloud.ibm.com
sudo logdna-agent -d /path/to/log/folders
sudo logdna-agent -t mytag,myothertag 
sudo update-rc.d logdna-agent defaults 
sudo /etc/init.d/logdna-agent start
curl -s https://s3.amazonaws.com/download.draios.com/stable/install-agent | sudo bash -s -- --access_key $2 --collector ingest.eu-gb.monitoring.cloud.ibm.com --collector_port 6443 --secure true
