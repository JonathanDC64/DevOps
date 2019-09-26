#!/bin/bash

# Add necessary locale value
echo 'LC_ALL=en_US.UTF-8' >> /etc/default/locale
echo 'LC_ALL=en_US.UTF-8' >> ~/.bash_profile
. ~/.bash_profile

# Refresh your repositories
sudo apt-get update

# Install the necessary prerequisites
echo "Installing the prerequisites"

sudo apt-get install -y apache2 php php-mbstring php-zip phpunit unzip libapache2-mod-php

# Start Web server
sudo service apache2 start
