# Read the input values
ec2-user=${{ inputs.username }}
command=${{ inputs.command }}
ec2-hostname=${{ inputs.ec2_instance_id }}

# Use Proxy command to connect to the EC2 instance
result=$(ssh -o ProxyCommand="sh -c "aws sso login; aws ec2-instance-connect send-ssh-public-key --instance-id $ec2-hostname --instance-os-user $ec2-user --ssh-public-key "file://$HOME/.ssh/id_rsa.pub"; aws ssm start-session --target $ec2-hostname --document-name AWS-StartSSHSession --parameters 'portNumber=22'"" "$command")


# Set the output value
echo "command_output=$result" >> $GITHUB_OUTPUT