#!/bin/bash

~/.ssh/config

echo 'Host * StrictHostKeyChecking no' > ~/.ssh/config

curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | sudo bash

cd /usr/bin

sudo apt-get install git-lfs
 
cd /home
 
git clone git@github.com:CCheCastaldo/MAPPPD-Model.git
