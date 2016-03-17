#!/bin/bash 

# spawn instance and store id
instance_id=$(aws ec2 run-instances --image-id ami-d1e792b1 --security-group-ids sg-7342b517 --count 1 --instance-type t2.micro --key-name CheCastaldoAmazon --instance-initiated-shutdown-behavior terminate --query 'Instances[0].{d:InstanceId}' --output text)

# wait until instance is up and running
aws ec2 wait instance-running --instance-ids $instance_id

# retrieve public dns
dns=$(aws ec2 describe-instances --instance-ids $instance_id --query 'Reservations[*].Instances[*].PublicDnsName' --output text | grep a)

# secure copy git private key to instance
scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i ~/.ssh/CheCastaldoAmazon.pem ~/.ssh/id_rsa ubuntu@$dns:~/.ssh/

# change permissons so ubuntu can write to home directory
ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i ~/.ssh/CheCastaldoAmazon.pem ubuntu@$dns "sudo chown -R ubuntu:ubuntu /home"

# copy over Job.bash to instance
scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i ~/.ssh/CheCastaldoAmazon.pem /users/coldwater/Desktop/Job.bash ubuntu@$dns:/home

# run job script on instance
ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i ~/.ssh/CheCastaldoAmazon.pem ubuntu@$dns "bash Job.bash &"

