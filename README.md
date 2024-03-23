# EC2 SSH GitHub Actions

This contains a GitHub action to send an ssh command to an EC2 instance using the ec2 instance connect proxy.  It enables running commands against an EC2 instance that does not have a public IP.

This action expects the usage of the [configure-aws-credentials](https://github.com/aws-actions/configure-aws-credentials) action.  It is best to use the `role-to-assume` identity to assume Role directly using GitHub OIDC provider.  This allows things to work without having to manage/store ssh keys.

## Workflow

### `action.yml`

This action metadata file will do the following when used:

1.  Use these inputs:
  username - the ssh username to use
  command - the ssh command to send
  ec2_instance_id - the target ec2 instance to send the ssh command to
  region - the region the ec2 instance resides

2.  Provide the output of the command with ${{ steps.run.outputs.command_output }}

## Usage Example

```
name: SSH test

on:
    workflow_dispatch:
      inputs:
        username:
          required: true
          type: string
        command:
          required: true
          type: string
        ec2_instance_id:
          required: true
          type: string
        region:
          required: true
          type: string
permissions:
            id-token: write  
jobs:
  run-ssh-command:
    runs-on: ubuntu-latest
    steps:  
        - name: configure aws credentials
          uses: aws-actions/configure-aws-credentials@v4
          with:
            role-to-assume: ${{ secrets.YOUR_ROLE_ARN }}
            aws-region: ${{ inputs.region }}
        - name: Run SSH Command
          id: ssh-command
          uses: leonowski/ec2-ssh-ghactions@v1
          with:
            username: ${{ inputs.username }}
            command: ${{ inputs.command }}
            ec2_instance_id: ${{ inputs.ec2_instance_id }}
            region: ${{ inputs.region }}

        - name: Output
          run: |
            echo -e "${{ steps.ssh-command.outputs.command_output }}"
```

The workflow will now be triggered based on the configured events and perform SSH connections to your EC2 instance securely using the EC2 Instance Connect proxy.

## Security Considerations

It's important to properly manage access to your EC2 instances and restrict SSH access to only what is necessary for your workflows.
