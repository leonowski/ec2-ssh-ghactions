#!/usr/bin/env bash
# Read the input values
ec2-user=${{ inputs.username }}
command=${{ inputs.command }}
ec2-hostname=${{ inputs.ec2_instance_id }}

# Generate temporary keypair
ssh-keygen -t rsa -b 4096 -f $HOME/.ssh/id_rsa

# Send the public key to the EC2 instance
aws ec2-instance-connect send-ssh-public-key --instance-id $ec2-hostname --instance-os-user $ec2-user --region $AWS_REGION --ssh-public-key "file://$HOME/.ssh/id_rsa.pub"

# SSH command to execute
result=$(ssh -i $HOME/.ssh/id_rsa $ec2-user@$ec2-hostname $command)


# Set the output value
echo "command_output=$result" >> $GITHUB_OUTPUT