#!/bin/bash 

#Clone git repo
git clone git@github.com:bw4sz/ec2.git

#cd into directory
cd ec2

#set global 
git config --global email.address "benweinstein2010@gmail.com"
git config --global user.name "bw4sz"

#install packages
sudo Rscript install.R

#Run main R script
cd ..
Rscript NegativeBinomial.R $1

#creates a useless Rplots file
rm Rplots.pdf

#add changes
git add Dispersion/*

#commit changes
git pull --no-edit
git commit -m "ec2 run complete"

git status

#slightly tricky part, trying not to type this all in plain text.

git push 

echo "Run Complete"
#Kill the instance
#sudo halt