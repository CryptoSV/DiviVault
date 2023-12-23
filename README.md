# Divi cold vault scripts

Scripts used with the Divi cold vault for monitoring and notifications.


# Instructions for the current.sh script:

This script checks the Divi staking status. If there is an issue, it will add it to the log file and send an AWS SNS alert message.

There *are* two variables that *MUST* be updated for this script to work.

You'll need to update the sns_arn variable with your AWS SNS topic ARN. You can find it in the AWS console under SNS / Topics / [your DIVI vault topic].
You'll also need to update the aws_region variable to the correct AWS region. You can find the region in the ARN.

Here is an example SNS ARN:
arn:aws:sns:us-east-2:556767245239:MyVaultReward

In this case, your two variable updates will look like this:

sns_arn="arn:aws:sns:us-east-2:556767245239:MyVaultReward"
aws_region="us-east-2"
