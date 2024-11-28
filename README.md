# Ubuntu Lab Environment Setup Script

## Description
This script automates the installation process of essential programs required for setting up a lab environment from scratch. It installs VMware, VirtualBox, Wireshark with GUI, GNS3, and Cisco Packet Tracer. Additionally, it includes a troubleshooting section for resolving issues related to Cisco Packet Tracer installation.

## Target Audience
This script is designed for IT managers, students, and professionals studying or working in networking, cybersecurity, or DevOps cloud environments. It aims to provide a convenient solution for preparing lab environments for practical exercises and experiments.

## Features
- Installs VMware, VirtualBox, Wireshark with GUI, GNS3, and Cisco Packet Tracer.
- Troubleshooting section for resolving Cisco Packet Tracer installation issues.
- Simple configuration for VPN setup, suitable for users with low internet connection or access restrictions in their network.
- Provides free OpenVPN configuration servers for easy VPN setup.

## Prerequisites
- A 64-bit Intel or AMD64 architecture-based system.
- Ubuntu Desktop with a GUI environment.
- At least 20 GB of free disk space available for installing the required programs.
- A minimum of 4 GB RAM to ensure smooth operation of the installed software.
- Root access to the system to execute the script and install software.

## Usage
1. Clone this repository to your local machine.
2. Open a terminal and navigate to the directory containing the script.
3. Make the script executable: `chmod +x setup_lab.sh`
4. Run the script: `sudo ./setup_lab.sh`
5. Follow the on-screen instructions to complete the installation process.

## Notes
- Ensure you have sufficient disk space available for installing the required programs.
- In case of any issues during installation, refer to the troubleshooting section in this README file.
- Feel free to contribute to this project by suggesting improvements or reporting issues.

## Troubleshooting
If you encounter any issues with the Cisco Packet Tracer installation, please try the following steps:
1. Ensure that you have downloaded the correct version of Cisco Packet Tracer for your operating system.
2. Check for any conflicting software that might interfere with the installation process.
3. Verify that you have the necessary permissions to install software on your system.
4. If the issue persists, refer to the official documentation or community forums for further assistance.

## VPN Configuration
If you have a low internet connection or face access restrictions in your network, you can use the provided simple configuration to set up a VPN connection. Follow the instructions provided in the script to configure the VPN.

## Free OpenVPN Configuration Servers
For easy VPN setup, you can use the following free OpenVPN configuration servers:
- [OpenTunnel](https://opentunnel.net/openvpn/#gsc.tab=0)
- [VPN Gate](https://www.vpngate.net/en/)
- [FreeVPN4You](https://freevpn4you.net/)

## License
This project is under the [MIT License](https://opensource.org/licenses/MIT).
