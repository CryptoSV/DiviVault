#!/bin/bash

# Scripts:
echo "This script:"
echo " -Creates two directories called scripts and logs"
echo " -Downloads two notification scripts"
echo "  Location: /home/admin/scripts"
echo "  1. current.sh"
echo "  2. allVaultRewards.sh"
echo " -Updates both file permissions"
echo " -Sets up a log file"
echo " -Asks you for your Amazon SNS ARN and Chainz CryptoID key"
echo " -Updates the files with your Amazon SNS ARN, Region (found in the ARN), and CryptoID key"
echo " -Sets up crontab (scheduler) to run the two scripts every minute"
read -n 1 -s -r -p "Press the spacebar to continue. Or, Control-c to exit."

mkdir /home/admin/scripts
mkdir /home/admin/logs

wget -P /home/admin/scripts https://raw.githubusercontent.com/CryptoSV/DiviVault/main/current.sh
wget -P /home/admin/scripts https://raw.githubusercontent.com/CryptoSV/DiviVault/main/allVaultRewards.sh

chmod +x /home/admin/scripts/allVaultRewards.sh
chmod +x /home/admin/scripts/current.sh
touch /home/admin/logs/stakingStatus.log

echo ""

# Ask the user for the full ARN
read -p "Enter the full AWS SNS ARN (e.g., arn:aws:sns:us-west-2:992382426593:VaultNotification): " full_arn

# Use cut to extract the region
# ARN format: arn:partition:service:region:account-id:resource
region=$(echo "$full_arn" | cut -d':' -f4)

# Ask the user for the CryptoID
read -p "Enter your Chainz CryptoID key: " cryptoID_key


# The path to the scripts files that needs to be updated
script_all="/home/admin/scripts/allVaultRewards.sh"
script_cur="/home/admin/scripts/current.sh"

# Check if script_all.sh exists
if [ ! -f "$script_all" ]; then
    echo "Error: $script_all does not exist."
    exit 1
fi

# Check if script_cur.sh exists
if [ ! -f "$script_cur" ]; then
    echo "Error: $script_cur does not exist."
    exit 1
fi


# Use sed to replace [Your SNS ARN] with the user's full_arn in script_all.sh
sed -i "s|\[Your SNS ARN\]|$full_arn|g" "$script_all"

# Use sed to replace [Your AWS Region] with the user's region in script_all.sh
sed -i "s|\[Your AWS Region\]|$region|g" "$script_all"

# Use sed to replace [Your CryptoID key] with the user's region in script_all.sh
sed -i "s|\[Your CryptoID key\]|$cryptoID_key|g" "$script_all"

echo "allVaultRewards.sh has been updated with your SNS ARN, region, and CryptoID key."

# Use sed to replace [Your SNS ARN] with the user's full_arn in script_all.sh
sed -i "s|\[Your SNS ARN\]|$full_arn|g" "$script_cur"

# Use sed to replace [Your AWS Region] with the user's region in script_all.sh
sed -i "s|\[Your AWS Region\]|$region|g" "$script_cur"

echo "current.sh has been updated with your SNS ARN and region."

echo "Updating crontab to run the current.sh and AllVaultRewards.sh scripts every minute."

sudo wget -P /etc/cron.d https://raw.githubusercontent.com/CryptoSV/DiviVault/main/per_minute
