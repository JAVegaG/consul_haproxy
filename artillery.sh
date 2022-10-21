#!/bin/bash

echo -e "\nInstalando Node.js y npm\n"

sudo curl -sL https://deb.nodesource.com/setup_16.x | sudo -E bash -
sudo apt install nodejs -y

echo -e "\nInstalando Artillery"

sudo npm install -g artillery

echo -e "\nCorriendo un test inicial"

sudo artillery run -e local load-test.yml > test$(date +%Y%m%d).log