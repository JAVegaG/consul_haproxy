#!/bin/bash

# Bash script to bootstrapping a consul datacenter

# cluster.sh 192.168.100.1k follower 5000
#                   $1          $2    $3

myIp=$1
myRole=$2
myPort=$3

echo -e "\nProvisionando\n"

sudo apt update

echo -e "\nInstalando Consul\n"

sudo wget -O- https://apt.releases.hashicorp.com/gpg \
| gpg --dearmor | \
sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
sudo echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" \
| sudo tee /etc/apt/sources.list.d/hashicorp.list

sudo apt update && sudo apt install consul -y

if [[ $myRole == "leader" ]]; then

    echo -e "\nconfigurando servidor haproxy\n"

    sudo apt install haproxy -y

    sudo mv -v /home/vagrant/haproxy.cfg /etc/haproxy/haproxy.cfg
    sudo mv -v /home/vagrant/sorry.http /etc/haproxy/errors/sorry.http

    sudo systemctl enable haproxy
    sudo systemctl restart haproxy

    echo -e "\nCreando llave de cifrado del clustér\n"

    key=$(consul keygen) # guardar la llave generada por consul en la variable key

    sudo sed -i "s|\"encrypt\"\:\ \".*\"|\"encrypt\"\:\ \"$key\"|g" cluster.json
    
    sudo cp -v cluster.json /vagrant/cluster.json

elif [[ $myRole == "follower" ]]; then

    echo -e "\nInstalando Node.js y npm\n"

    sudo curl -sL https://deb.nodesource.com/setup_16.x | sudo -E bash -
    sudo apt install nodejs -y

    echo -e "\nDescargando servicio Web"

    sudo git clone https://github.com/omondragon/consulService
    sudo cp -v consulService/app/index.js .index.js # Ubico el index.js en /home/vagrant/ y lo oculto

    echo -e "\nInstalando dependencias\n"

    sudo npm init -y && sudo npm install consul && sudo npm install express

    echo -e "\nConfigurando servicio web\n"

    sudo sed -i "s|mymicroservice|web|g" .index.js # le acambio el nombre a la app
    sudo sed -i "s|process\.argv\[2\]|process\.argv\[3\]|g" .index.js # en lugar de revisar el arg2, revise el arg3
    sudo sed -i "s|'192\.168\.100\.3'|process\.argv\[2\]|g" .index.js

    sudo sed -i "s|myIp|$myIp|g" web.service
    sudo sed -i "s|myPort|$myPort|g" web.service
    
    sudo mv -v web.service /etc/systemd/system/web.service
    
    sudo systemctl daemon-reload

    sudo systemctl restart web
    sudo systemctl enable web

fi

echo -e "\nConfigurando el Clustér\n"

sudo sed -i "s|myIp|$myIp|g" cluster.json
sudo mv -v cluster.json /etc/consul.d/cluster.json

echo -e "\nConfigurar el servicio de consul\n"

sudo mv -v consul.service /etc/systemd/system/consul.service
sudo systemctl daemon-reload

sudo systemctl restart consul
sudo systemctl enable consul