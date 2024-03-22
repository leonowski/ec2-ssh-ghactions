#!/usr/bin/env bash

# Generate temporary keypair
ssh-keygen -t rsa -b 4096 -f $HOME/.ssh/id_rsa -N ""

# Send the public key to the EC2 instance
aws ec2-instance-connect send-ssh-public-key --instance-id ${EC2_INSTANCE_ID} --instance-os-user ${USERNAME} --region ${AWS_REGION} --ssh-public-key "file://$HOME/.ssh/id_rsa.pub"

# SSH command to execute
result=$(ssh -i $HOME/.ssh/id_rsa $ec2-user@$ec2-hostname ${COMMAND})

# Set the output value
echo "command_output=$result" >>$GITHUB_OUTPUT
