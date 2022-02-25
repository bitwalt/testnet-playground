#!/bin/bash

#  update, upgrade and install docker
sudo apt-get update && sudo apt-get upgrade
curl -sSL https://get.docker.com | sh
    
# Add current user to docker group
sudo usermod -aG docker ${USER}

# Install python, pip and docker-compose
sudo apt-get install libffi-dev libssl-dev
sudo apt install python3-dev
sudo apt-get install -y python3 python3-pip
sudo pip3 install docker-compose
# Enable the Docker system service to start your containers on boot
sudo systemctl enable docker
