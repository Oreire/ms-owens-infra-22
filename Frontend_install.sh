#!/bin/bash

#Scripts the installation of git, npm and netcat packages on the provisioned EC2 Frontend Node 1 and Frontend Node 2 Servers

sudo yum install git -y
sudo yum install npm -y
sudo yum intsall nc -y
#user_data = "${file(Frontend-install.sh)}"