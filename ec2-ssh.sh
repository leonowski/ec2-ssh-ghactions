#!/usr/bin/env bash

set -xe

# Generate temporary keypair
ssh-keygen -t rsa -b 4096 -f $HOME/.ssh/id_rsa -N ""

# Send the public key to the EC2 instance
aws ec2-instance-connect send-ssh-public-key --instance-id ${EC2_INSTANCE_ID} --instance-os-user ${USERNAME} --region ${AWS_REGION} --ssh-public-key "file://$HOME/.ssh/id_rsa.pub"

# SSH command to execute
result=$(ssh -tt -o 'ProxyCommand aws ssm start-session --target ${EC2_INSTANCE_ID} --document-name AWS-StartSSHSession --parameters 'portNumber=22'' -o StrictHostKeyChecking=no ${USERNAME}@${EC2_INSTANCE_ID} "${COMMAND}")

# Set the output value
echo "command_output<<EOF" >>$GITHUB_OUTPUT
echo "$result" >>$GITHUB_OUTPUT
echo "EOF" >>$GITHUB_OUTPUT
