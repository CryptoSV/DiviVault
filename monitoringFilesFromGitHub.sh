#!/bin/bash

# Scripts:
echo "Section 1 of 3"
echo "This section:"
echo " -Downloads four monitoring scripts used with New Relic"
echo "  Location: /home/admin/scripts"
echo "  1. countMyRewards.sh"
echo "  2. getCurrentVaultValue.sh"
echo "  3. nicenumber.sh"
echo "  4. stakeStatus.sh"
echo " -Updates their permissions"
echo " -Sets up a log file"
read -n 1 -s -r -p "Press spacebar to continue..."

wget -P /home/admin/scripts https://raw.githubusercontent.com/CryptoSV/DiviVault/main/countMyRewards.sh
wget -P /home/admin/scripts https://raw.githubusercontent.com/CryptoSV/DiviVault/main/getCurrentVaultValue.sh
wget -P /home/admin/scripts https://raw.githubusercontent.com/CryptoSV/DiviVault/main/nicenumber.sh
wget -P /home/admin/scripts https://raw.githubusercontent.com/CryptoSV/DiviVault/main/stakeStatus.sh
chmod +x /home/admin/scripts/*
touch /home/admin/logs/allVaultRewards.log

# New Relic Logging.d:
echo "Section 2 of 3"
echo "This section:"
echo " -Saves the default New Relic logging.yml file to logging.yml.example"
echo " -Downloads two logging files used with New Relic"
echo "  Location: /etc/newrelic-infra/logging.d"
echo "  1. logging.yml"
echo "  2. stakingStatus.yml"
read -n 1 -s -r -p "Press spacebar to continue..."

sudo mv /etc/newrelic-infra/logging.d/logging.yml /etc/newrelic-infra/logging.d/logging.yml.example
sudo wget -P /etc/newrelic-infra/logging.d https://raw.githubusercontent.com/CryptoSV/DiviVault/main/logging.yml
sudo wget -P /etc/newrelic-infra/logging.d https://raw.githubusercontent.com/CryptoSV/DiviVault/main/stakingStatus.yml

# New Relic Integrations.d:
echo "Section 3 of 3"
echo "This section:"
echo " -Downloads three integration files used with New Relic"
echo "  Location: /etc/newrelic-infra/integrations.d"
echo "  1. flexCountCountRewards.yml"
echo "  2. flexStakingStatus.yml"
echo "  3. flexVaultCurrentValue.yml"
read -n 1 -s -r -p "Press spacebar to continue..."

sudo wget -P /etc/newrelic-infra/integrations.d https://raw.githubusercontent.com/CryptoSV/DiviVault/main/flexCountRewards.yml
sudo wget -P /etc/newrelic-infra/integrations.d https://raw.githubusercontent.com/CryptoSV/DiviVault/main/flexStakingStatus.yml
sudo wget -P /etc/newrelic-infra/integrations.d https://raw.githubusercontent.com/CryptoSV/DiviVault/main/flexVaultCurrentValue.yml
