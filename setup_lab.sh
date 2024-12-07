#!/bin/bash
# ===========================
# Error Resource Documentation
# ===========================
# This section provides links to resources for troubleshooting errors
# encountered while installing Cisco Packet Tracer on Ubuntu 23.10.
# For detailed guidance, refer to the following GitHub repository:
# https://github.com/PetrusNoleto/Error-in-install-cisco-packet-tracer-in-ubuntu-23.10-unmet-dependencies?tab=readme-ov-file

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

# URLs for downloads
VMWARE_URL="https://github.com/lyonzon2/Network-Environment-Builder/releases/download/VMware-Workstation-Full-17.6.1/VMware-Workstation-Full-17.6.1-24319023.x86_64.bundle"
PACKETTRACER_URL="https://github.com/lyonzon2/Network-Environment-Builder/releases/download/CiscoPacketTracer_821_Ubuntu_64bit.deb/CiscoPacketTracer_821_Ubuntu_64bit.deb"
PACKETTRACER_DEP_URL="https://github.com/PetrusNoleto/Error-in-install-cisco-packet-tracer-in-ubuntu-23.10-unmet-dependencies/releases/download/CiscoPacketTracerFixUnmetDependenciesUbuntu23.10/libegl1-mesa_23.0.4-0ubuntu1.22.04.1_amd64.deb"
PACKETTRACER_DEP_URL2="https://github.com/PetrusNoleto/Error-in-install-cisco-packet-tracer-in-ubuntu-23.10-unmet-dependencies/releases/download/CiscoPacketTracerFixUnmetDependenciesUbuntu23.10/libgl1-mesa-glx_23.0.4-0ubuntu1.22.04.1_amd64.deb"

# Function to display a rotating spinner
spinner() {
    local pid=$1
    local delay=0.1
    local spinstr='|/-\'
    while ps -p $pid > /dev/null; do
        for i in ${spinstr}; do
            echo -ne "\b$i"
            sleep $delay
        done
    done
    echo -ne "\b"
}

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

# Function to display the logo with a typing effect
function display_project_logo() {
    # Define colors
    local blue='\e[1;34m'
    local reset='\e[0m'

    # Logo lines stored in an array
    local project_logo=(
        "  _______            _    _                _    _               "
        " |__   __|  __ _  __| |_  |_ ___ _ __  _ __ | |_ (_) ___  _ __  "
        "    |_ |_ |/ _\` |/ / __| __| / __| '__|/ _ \\| __| |/ _ \\| '__| "
        "     _| |_ | (_|   |_ |_ |_ |_ |_ |_  |_ |_ |_ |_ |_ |_ |_  "
        "    (_) (_)\\__,_|\\__|\\__|\\__|_| (_) (_) |_(_)_(_) (_) (_) "
        " "
        "    Ubuntu Lab Environment Setup Script"
        "    -------------------------------------"
        "    Automating your lab setup with ease."
    )

    # Print each line with a typing effect
    for line in "${project_logo[@]}"; do
        echo -e "${blue}${line}${NC}"  # Print the entire line at once
        sleep 0.05  # Adjust the speed of typing effect
    done

    printf "${reset}\n"  # Reset color to default
}

# Function to check and display public IP and additional info
check_public_ip() {
    echo -e "\n${GREEN}Verifying your public IP to ensure VPN connectivity...${NC}"
    local ip_info=$(curl -s ipinfo.io)
    local ip=$(echo "$ip_info" | jq -r '.ip')
    local city=$(echo "$ip_info" | jq -r '.city')
    local region=$(echo "$ip_info" | jq -r '.region')
    local country=$(echo "$ip_info" | jq -r '.country')
    local org=$(echo "$ip_info" | jq -r '.org')

    echo -e "Your public IP is: ${YELLOW}$ip${NC}"
    echo -e "Location: ${YELLOW}$city, $region, $country${NC}"
    echo -e "Organization: ${YELLOW}$org${NC}"
    echo -e "${GREEN}If you are using a VPN, ensure the IP is as expected.${NC}\n"
}

# Function to connect using OpenVPN
connect_openvpn() {
    echo -e "${GREEN}Connecting to OpenVPN...${NC}"
    # Assuming the configuration files are in the current project directory
    for file in openvpn/*.ovpn; do
        echo -e "${BLUE}Connecting to $file...${NC}"
        if openvpn --config "$file"; then
            echo -e "${GREEN}Connected to $file.${NC}"
            break
        else
            echo -e "${RED}Failed to connect to $file. Trying the next one...${NC}"
        fi
    done
}

# Ask if the user wants to use OpenVPN configurations
echo -e "${BLUE}Do you want to use OpenVPN configurations? (yes/no): ${NC}" 
read use_openvpn
if [[ $use_openvpn == "yes" ]]; then
    connect_openvpn
else
    echo -e "${YELLOW}OpenVPN configurations will not be used.${NC}"
fi

# Call the function to check public IP
check_public_ip

# Update and install necessary packages
echo -e "${BLUE}Would you like to perform an update with all necessary dependencies? (yes/no): ${NC}"
read answer1 
if [[ $answer1 == "yes" ]]; then
    echo -e "${GREEN}Updating package lists and upgrading installed packages...${NC}"
    apt update -y 
    apt upgrade -y
    apt install -y build-essential git openvpn base64 curl wget --progress=dot  software-properties-common
    apt install gdebi -y 
else
    echo -e "${YELLOW}Skipping updates... Proceeding to the next step.${NC}"
fi 

# Print the project logo
display_project_logo

echo -e "${BLUE}----------------------------- PART 2 ------------------------------------------------- ${NC}"

# Function to display the menu
display_menu() {
    local width=50
    local border_color="\e[1;34m"  # Light blue color for border
    local text_color="\e[1;37m"    # White color for text
    local reset="\e[0m"            # Reset color to default

    # Print the top border and menu title
    printf "${border_color}+-%*s-+\n" "$width" ""
    printf "${border_color}|%-*s${reset} Select Programs to Install:\n" $((width -2)) " "  # Adjusted spacing
    printf "${border_color}+-%*s-+\n" "$width" ""

    # Menu options
    echo -e "${border_color}| ${text_color}1. gns3 🌐 ${border_color}|"
    echo -e "${border_color}| ${text_color}2. vmware 💻 ${border_color}|"
    echo -e "${border_color}| ${text_color}3. virtualbox 📦 ${border_color}|"
    echo -e "${border_color}| ${text_color}4. packettracer 📡 ${border_color}|"
    echo -e "${border_color}| ${text_color}5. warp vpn ⚡ ${border_color}|"
    echo -e "${border_color}| ${text_color}6. fix_packettracer 🚨 ${border_color}|"
    
    # Print the bottom border
    printf "${border_color}+-%*s-+\n" "$width" ""
}

# Display the menu
display_menu

# Ask the user to select programs
echo -e "${BLUE}Please enter the program numbers you wish to install (e.g., 1 2 3): ${NC}"
read selected_programs

# Function to install GNS3
install_GNS3() {
    echo -n "Installing GNS3..."
    (sleep 3) &
    spinner $!
    print_message "Begin!" $GREEN
    add-apt-repository -y ppa:gns3/ppa
    apt update -y
    apt install -y gns3-gui gns3-server
    dpkg --add-architecture i386
    apt update -y 
    apt install -y gns3-iou
    print_message "Done!" $GREEN
}

# Function to install VMware
install_VMWARE() {
    echo -n "Downloading VMware..."
    if [ ! -f "VMware-Workstation*" ]; then
        wget --progress=dot  $VMWARE_URL
    fi
    (sleep 3) &
    spinner $!
    echo -n "Installing VMware..."
    print_message "Begin!" $GREEN
    chmod +x VMware-Workstation*
    ./VMware-Workstation*
    print_message "Done!" $GREEN
    echo "Your VMware Pro serial key:" ; cat assets/vmware-serial-key.txt
}

# Function to install VirtualBox
install_VIRTUALBOX() {
    echo -n "Installing VirtualBox..."
    (sleep 3) &
    spinner $!
    print_message "Begin!" $GREEN
    apt install -y virtualbox
    apt install -y virtualbox-ext-pack
    print_message "Done!" $GREEN
}

# Function to install PacketTracer
install_PACKET-TRACER() {
    echo -n "Downloading dependencies and installing PacketTracer..."
    if [ ! -f "CiscoPacketTracer_*.deb" ]; then
        wget --progress=dot  $PACKETTRACER_URL
    fi
    if [ ! -f "libgl1-mesa-glx_*.deb" ]; then
        wget --progress=dot  $PACKETTRACER_DEP_URL
    fi
    if [ ! -f "libegl1-mesa_*.deb" ]; then
        wget --progress=dot  $PACKETTRACER_DEP_URL2
    fi
    (sleep 3) &
    spinner $!
    print_message "Begin!" $GREEN
    chmod +x lib*
    chmod +x CiscoPacketTracer_*.deb
    echo "Warning: This step may require interaction from you. Press 'y' if prompted."
    echo 'Beginning installation...'
    echo "y" | gdebi ./libgl1-mesa-glx*.deb
    echo "y" | gdebi ./libegl1-mesa*.deb
    echo "y" | gdebi ./CiscoPacketTracer_*.deb
    print_message "System update, package installation, and cleanup completed." $GREEN
}

# Function to install WARP VPN
install_WARP-VPN() {
    echo -n "Installing WARP..."
    (sleep 3) &
    spinner $!
    print_message "Begin!" $GREEN

    # Install pip3 if not already installed
    if ! command -v pip3 &> /dev/null; then
        echo -e "${YELLOW}pip3 not found. Installing...${NC}"
        apt-get install -y python3-pip
    fi

    # Download and setup Cloudflare signing key
    wget --progress=dot -q https://pkg.cloudflareclient.com/pubkey.gpg
    gpg --yes --dearmor -o /usr/share/keyrings/cloudflare-archive-keyring.gpg pubkey.gpg
    rm pubkey.gpg
    
    # Add Cloudflare repository
    echo 'deb [signed-by=/usr/share/keyrings/cloudflare-archive-keyring.gpg arch=amd64] https://pkg.cloudflareclient.com/ focal main' | tee /etc/apt/sources.list.d/cloudflare-client.list > /dev/null
    
    # Install WARP client
    apt-get update
    apt-get install -y cloudflare-warp

    # ReRegister 
    echo "Deleting old WARP client registration..."
    yes | warp-cli registration delete

    # Register and connect
    echo "Registering new WARP client..."
    yes | warp-cli registration new
    
    echo "Connecting to WARP..."
    warp-cli connect
    
    # Verify connection
    echo -e "${GREEN}Verifying connection...${NC}"
    sleep 2
    connection_info=$(curl -s https://www.cloudflare.com/cdn-cgi/trace/)
    echo -e "${GREEN}$connection_info${NC}"
    print_message "Warp has been installed seccussfully" $GREEN
    # Install GUI (optional)
   # echo "Installing WARP GUI..."
   # if [ ! -d "warp-cloudflare-gui" ]; then
   #     git clone https://github.com/mrmoein/warp-cloudflare-gui
   # fi

   #cd warp-cloudflare-gui
   # mkdir -p ~/.config/pip && echo -e "[global]\nbreak-system-packages = true" > ~/.config/pip/pip.conf

    # Change the installation directory for the desktop file
    #local desktop_file="/usr/share/applications/warp-gui.desktop"
    #python3 install.py --desktop-file "$desktop_file"  # Pass the desktop file path

    #cd ..
    #rm -rf warp-cloudflare-gui
    #print_message "Done!" $GREEN
}

# Function to fix PacketTracer
fix_packettracer() {
   echo -n "Fixing all for you..." 
   (sleep 3) &
   spinner $!
   print_message "Begin!" $GREEN
   apt install -f
   apt autoremove
   apt autoclean
   apt clean
   dpkg --configure -a
   apt --fix-broken install
   dpkg --remove --force-all packettracer
   dpkg --remove --force-remove-reinstreq packettracer
   apt-get update 
   print_message "Done!" $GREEN   
}

# Iterate over the selected program numbers and call the corresponding functions
for program_number in $selected_programs; do
    case $program_number in
        1) 
            echo -e "${GREEN}Installing GNS3...${NC}"
            install_GNS3 
        ;;
        2) 
            echo -e "${GREEN}Installing VMware...${NC}"
            install_VMWARE 
        ;;
        3) 
            echo -e "${GREEN}Installing VirtualBox...${NC}"
            install_VIRTUALBOX 
        ;;
        4) 
            echo -e "${GREEN}Installing PacketTracer...${NC}"
            install_PACKET-TRACER 
        ;;
        5) 
            echo -e "${GREEN}Installing WARP VPN...${NC}"
            install_WARP-VPN 
        ;;
        6) 
            echo -e "${GREEN}Fixing PacketTracer...${NC}"
            fix_packettracer 
        ;;
        *) 
            echo -e "${RED}Invalid program number: $program_number${NC}"
        ;;
    esac
done

# Ask if the user wants to run installed programs
echo -e "${BLUE}Do you want to run installed programs? (yes/no): ${NC}"
read answer
answer=$(echo "$answer" | tr '[:upper:]' '[:lower:]')

# Check the user's input
if [ "$answer" == "yes" ]; then
    echo "Launching the installed programs..."
    
    # Array of programs to run
    programs=(vmware packettracer virtualbox gns3)

    # Loop through each program and run it
    for program in "${programs[@]}"; do
        echo -e "${GREEN}Running $program...${NC}"
        $program &  # Run the program in the background
        sleep 5     # Wait for a few seconds before starting the next one
    done
else
    echo -e "Exiting the script. Have a great day! \xF0\x9F\x98\x83"
    exit 0
fi
