# Divi cold vault scripts

Scripts used with the Divi cold vault for monitoring and notifications.

Place all .sh script files in: /home/admin/scripts

Place all flex... files in: /etc/newrelic-infra/integrations.d

Place the logging.yml and stakingStatus.yml files in: /etc/newrelic-infra/logging.d

Change the access mode of each .sh script by running: chmod +x [file]

# Instructions for the current.sh script:

This is a standalone script that checks the Divi staking status. If there is an issue, it will add it to the log file and send an AWS SNS alert message.

To make sure it runs every minute, run:

crontab -e
(If asked, select Nano.)
Add this line to the bottom:

[astrick] [astrick] [astrick] [astrick] [astrick] /home/admin/scripts/current.sh

Yes, there will be five astricks, each separated by a space.

There *are* two variables in the current.sh script that *MUST* be updated for this script to work.

1. You'll need to update the sns_arn variable with your AWS SNS topic ARN. You can find it in the AWS console under SNS / Topics / [your DIVI vault topic].
2. You'll also need to update the aws_region variable to the correct AWS region. You can find the region in the ARN.

Here is an example SNS ARN:
arn:aws:sns:us-east-2:516864295231:MyVaultReward

In this case, your two variable updates will look like this:

sns_arn="arn:aws:sns:us-east-2:516864295231:MyVaultReward"

aws_region="us-east-2"


# Instructions for the allVaultRewards.sh script:

This script looks for new vault rewards and sends a notification to AWS SNS with all the details of the reward.

To make sure it runs every minute, run:

crontab -e (If asked, select Nano.) Add this line to the bottom:

[astrick] [astrick] [astrick] [astrick] [astrick] /home/admin/scripts/allVaultRewards.sh

Yes, there will be five astricks, each separated by a space.

There *are* three variables in the allVaultRewards.sh script that MUST be updated for this script to work.

You must update the sns_arn variable with your AWS SNS topic ARN. You can find it in the AWS console under SNS / Topics / [your DIVI vault topic].
You must also update the aws_region variable to the correct AWS region. You can find the region in the ARN.
You'll also need an API key from Chainz CryptoID to get the current Divi price.

Here is an example SNS ARN: arn:aws:sns:us-east-2:516864295231:MyVaultReward

In this case, your three variable updates will look like this:

sns_arn="arn:aws:sns:us-east-2:516864295231:MyVaultReward"

aws_region="us-east-2"

cryptoid_key="0123ab456c78"
