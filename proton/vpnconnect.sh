#!/bin/bash

# Set the path to the Proton directory
proton_directory="proton"


# Get a random config file from the Proton directory
config_file=$(ls "$proton_directory" | shuf -n 1)

# Your encrypted credentials file
ENCRYPTED_FILE="proton/cred.enc"

# Decrypt and use credentials using -pbkdf2 and fixing backslash issue
credentials=$(openssl enc -d -aes-256-cbc -in "$ENCRYPTED_FILE" -k "Root2020@")
username=$(echo "$credentials" | awk 'NR==1 {print}')
password=$(echo "$credentials" | awk 'NR==2 {print}')

# Create a temporary file for OpenVPN credentials
temp_credentials_file=$(mktemp /tmp/openvpn-credentials-XXXXXX)
echo -e "$username\n$password" > "$temp_credentials_file"

# Run OpenVPN with the selected config file and user credentials
sudo openvpn --config "$proton_directory/$config_file" --auth-user-pass "$temp_credentials_file"

# Clean up
rm -f "$temp_credentials_file"
unset username
unset password

