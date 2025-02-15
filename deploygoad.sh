#!/bin/bash
echo "Deploy GOAD on Linux for pentest windows server"

# Ensure we're root
if [ "$(id -u)" != "0" ]; then
  echo "This script must be run as root" 1>&2
  exit 1
fi

# install dependances
apt install vagrant ansible pip python3-pip git &&

# Add repositories
add-apt-repository -y multiverse

# Get list of latest packages
apt-get update

# Install base packages needed
apt install git
apt-get install -y python3-pip pip vagrant
apt install python3.13-venv &&

# Enable IP forwarding on Ubuntu
if [ "`cat /proc/sys/net/ipv4/ip_forward`" != "1" ]; then
  # Implement in sysctl 
  echo net.ipv4.ip_forward = 1 >> /etc/sysctl.conf
  sysctl -p
fi

# Set up prerequisites, not doing a venv but could be changed to that
pip install ansible-core==2.12.6 --break-system-packages
pip install pywinrm --break-system-packages

# Install stuff needed for Vagrant
vagrant plugin install winrm
vagrant plugin install winrm-elevated

apt install ruby && gem install winrm-elevated

sudo vagrant plugin install vagrant-disksize
vagrant plugin install winrm
vagrant plugin install winrm-fs
vagrant plugin install winrm-elevated
vagrant plugin install vagrant-reload
vagrant plugin install vagrant-vbguest

echo "deb http://deb.debian.org/debian/ sid main contrib non-free" >> /etc/apt/sources.list
apt update &&
apt install virtualbox &&

# Download GOAD
if [ ! -d /opt/goad ]; then
  git clone https://github.com/Orange-Cyberdefense/GOAD.git /opt/goad &&
  mkdir /opt/goad/base
fi

# Install GOAD stuff needed for Ansible
ansible-galaxy install -r /opt/goad/ansible/requirements.yml

# Switch to GOAD folder and deploy VMs
bash /opt/goad/goad.sh -t install -l GOAD -p virtualbox -m local

if [ $? -ne 0 ]; then
  echo "Deployment failed"
  exit 1
fi

echo "Deployment succeeded, your lab is now up and running on the 192.168.56.0/24 network"
