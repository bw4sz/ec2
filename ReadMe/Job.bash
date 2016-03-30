#!/bin/bash

run=GenericEC2Run

# install Git LFS if necessary 

#curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | sudo bash

#cd /usr/bin

#sudo apt-get install git-lfs
 

# clone Git repository

cd /home
 
echo 'Host github.com
	StrictHostKeyChecking no' > ~/.ssh/config

git clone git@github.com:CCheCastaldo/MAPPPD-Model.git


# set global on git 

git config --global email.address "cccweb@icloud.com"

git config --global user.name "CCheCastaldo"



# checkout a new branch for current ec2 run

cd MAPPPD-Model

git checkout -b $run


# run R job

cd ModelBuild/$run

Rscript --no-save --no-restore --verbose Rsetup.R $run


# stage and commit changes

git add --all

git commit -m "ec2 run complete"


# push to remote repository of same name as run

git push -u origin $run



