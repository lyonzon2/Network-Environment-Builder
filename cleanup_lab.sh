#!/bin/bash
# ===========================
# Ubuntu Lab Environment Cleanup Script
# ===========================
# This script removes the installed programs and cleans up the system
# to roll back the changes made by the Ubuntu Lab Setup Script.

# Check for root privileges
if [ "$EUID" -ne 0 ]; then
    echo -e "\e[1;31mPlease run this script with sudo or as root.\e[0m"
    exit 1
fi

# Define colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'  # No Color

# Function to print a colored message
print_message() {
    local message=$1
    local color=$2
    local width=60
    local border_color="\e[1;34m"  # Light blue color for border
    local reset="\e[0m"            # Reset color to default

    # Print the top border
    printf "${border_color}+-%*s-+\n" "$width" ""
    printf "${border_color}|${reset} %-*s${border_color} |\n" $((width - 2)) "$message"
    printf "${border_color}+-%*s-+\n" "$width" ""
}

# Function to uninstall GNS3
uninstall_GNS3() {
    echo -n "Uninstalling GNS3..."
    (sleep 3) &
    spinner $!
    print_message "Begin!" $GREEN
    apt remove --purge -y gns3-gui gns3-server gns3-iou
    apt autoremove -y
    print_message "GNS3 uninstalled successfully!" $GREEN
}

# Function to uninstall VMware
uninstall_VMWARE() {
    echo -n "Uninstalling VMware..."
    (sleep 3) &
    spinner $!
    print_message "Begin!" $GREEN
    apt remove --purge -y vmware*
    apt autoremove -y
    print_message "VMware uninstalled successfully!" $GREEN
}

# Function to uninstall VirtualBox
uninstall_VIRTUALBOX() {
    echo -n "Uninstalling VirtualBox..."
    (sleep 3) &
    spinner $!
    print_message "Begin!" $GREEN
    apt remove --purge -y virtualbox virtualbox-ext-pack
    apt autoremove -y
    print_message "VirtualBox uninstalled successfully!" $GREEN
}

# Function to uninstall PacketTracer
uninstall_PACKET-TRACER() {
    echo -n "Uninstalling PacketTracer..."
    (sleep 3) &
    spinner $!
    print_message "Begin!" $GREEN
    apt remove --purge -y packettracer
    apt autoremove -y
    print_message "PacketTracer uninstalled successfully!" $GREEN
}

# Function to uninstall WARP VPN
uninstall_WARP_VPN() {
    echo -n "Uninstalling WARP VPN..."
    (sleep 3) &
    spinner $!
    print_message "Begin!" $GREEN
    apt remove --purge -y cloudflare-warp
    apt autoremove -y
    print_message "WARP VPN uninstalled successfully!" $GREEN
}

# Function to clean up residual files
cleanup() {
    echo -n "Cleaning up residual files..."
    (sleep 3) &
    spinner $!
    print_message "Begin!" $GREEN
    apt clean
    rm -rf ~/warp-cloudflare-gui
    print_message "Cleanup completed!" $GREEN
}

# Display menu for uninstallation
echo -e "${BLUE}----------------------------- Uninstallation Menu -----------------------------${NC}"
echo -e "${BLUE}Please select the programs you wish to uninstall (e.g., 1 2 3):${NC}"
echo -e "1. GNS3 🌐"
echo -e "2. VMware 💻"
echo -e "3. VirtualBox 📦"
echo -e "4. PacketTracer 📡"
echo -e "5. WARP VPN ⚡"
echo -e "6. All Programs 🚀"
echo -e "${BLUE}-------------------------------------------------------------------------------${NC}"

# Read user input
read selected_programs

# Iterate over the selected program numbers and call the corresponding functions
for program_number in $selected_programs; do
    case $program_number in
        1) 
            uninstall_GNS3 
            ;;
        2) 
            uninstall_VMWARE 
            ;;
        3) 
            uninstall_VIRTUALBOX 
            ;;
        4) 
            uninstall_PACKET-TRACER 
            ;;
        5) 
            uninstall_WARP_VPN 
            ;;
        6) 
            uninstall_GNS3
            uninstall_VMWARE
            uninstall_VIRTUALBOX
            uninstall_PACKET-TRACER
            uninstall_WARP_VPN
            ;;
        *) 
            echo -e "${RED}Invalid program number: $program_number${NC}";;
    esac
done

# Perform cleanup
cleanup

echo -e "${GREEN}All selected programs have been uninstalled and the system has been cleaned up!${NC}"