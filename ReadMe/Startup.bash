#!/bin/bash 

run=GenericEC2Run

# spawn instance and store id
instance_id=$(aws ec2 run-instances --image-id ami-d1e792b1 --security-group-ids sg-7342b517 --count 1 --instance-type t2.micro --key-name CheCastaldoAmazon --instance-initiated-shutdown-behavior terminate --query 'Instances[0].{d:InstanceId}' --output text)
echo "Waiting for instance to be in the running state..."

# wait until instance is up and running
aws ec2 wait instance-running --instance-ids $instance_id
echo "AWS instance $instance_id running"

# retrieve public dns
dns=$(aws ec2 describe-instances --instance-ids $instance_id --query 'Reservations[*].Instances[*].PublicDnsName' --output text | grep a)
echo "Public DNS is $dns"

# wait for SSH port to be available
echo "Waiting for SSH port to be available at $dns..."
wait_for_port() {
  local port=22
  local host=$dns
  while ! nc -z "$host" "$port" >/dev/null; do
    sleep 5
  done
}

wait_for_port
echo "For your convenience, to SSH to this instance copy/paste:"
echo "ssh -i ~/.ssh/CheCastaldoAmazon.pem ubuntu@$dns"
echo ""

# secure copy git private key to instance
scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i ~/.ssh/CheCastaldoAmazon.pem ~/.ssh/id_rsa ubuntu@$dns:~/.ssh/
echo "git private key copied successfully..."
echo ""

# change permissions so ubuntu can write to home directory
ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i ~/.ssh/CheCastaldoAmazon.pem ubuntu@$dns "sudo chown -R ubuntu:ubuntu /home"
echo "home directory ownership changed to ubuntu..."
echo ""

# change permissions so ubuntu can install R packages
ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i ~/.ssh/CheCastaldoAmazon.pem ubuntu@$dns "sudo chown -R ubuntu:ubuntu /usr/local/lib/R/site-library/"
echo "/usr/local/lib/R/site-library/ ownership changed to ubuntu..."
echo ""

scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i ~/.ssh/CheCastaldoAmazon.pem /Users/coldwater/Library/Mobile\ Documents/com~apple~CloudDocs/Research/MAPPPDModel/ModelBuild/$run/Job.bash ubuntu@$dns:/home
echo "Job.bash copied successfully to /home..."
echo ""

# run job script on instance
ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i ~/.ssh/CheCastaldoAmazon.pem ubuntu@$dns "bash /home/Job.bash"
echo "Job.bash completed"
echo ""

# terminate ec2 instance
#aws ec2 terminate-instances --instance-ids $instance_id
#echo "AWS instance $instance_id terminated"
#echo "Have a nice day"


