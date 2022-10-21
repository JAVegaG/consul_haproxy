# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|

        virtualmachine = 3

        (1..virtualmachine).each do |k| # for k in range(virtualmachine)
                config.vm.define "servidor#{k}" do |machine|

                        ipAddr = "192.168.100.1#{k}"
                        scriptArgs = [ipAddr] # Array con la ip[k]

                        machine.vm.box = "bento/ubuntu-22.04"
                        machine.vm.hostname = "servidor#{k}.microproyecto1.com"
                        machine.vm.network "private_network", ip: ipAddr
                        machine.vm.provision "file", source: "cluster.json", destination: "/home/vagrant/cluster.json"
                        machine.vm.provision "file", source: "consul.service", destination: "/home/vagrant/consul.service"
                        if k == 1
                                machine.vm.provision "file", source: "haproxy.cfg", destination: "/home/vagrant/haproxy.cfg"
                                machine.vm.provision "file", source: "sorry.http", destination: "/home/vagrant/sorry.http"
                                scriptArgs.concat(["leader"]) # array = [ipAddr, rol]
                        else
                                machine.vm.provision "file", source: "web.service", destination: "/home/vagrant/web.service"
                                scriptArgs.concat(["follower", "5000"]) # array = [ipAddr, rol, puerto]
                        end
                        machine.vm.provision "shell" do |s|
                                s.path = "cluster.sh"
                                s.args = scriptArgs # array resultante
                        end
                        machine.vm.provider "virtualbox" do |v|
                                v.name = "microproyecto_1_servidor#{k}"
                                v.memory = 1024
                                v.cpus = 1
                        end
                end
        end

        config.vm.define "cliente" do |machine|
                machine.vm.box = "bento/ubuntu-22.04"
                machine.vm.hostname = "cliente.microproyecto1.com"
                machine.vm.network "private_network", ip: "192.168.100.100"
                machine.vm.provision "file", source: "load-test.yml", destination: "/home/vagrant/load-test.yml"
                machine.vm.provision "shell", path: "artillery.sh"
                machine.vm.provider "virtualbox" do |v|
                        v.name = "microproyecto_1_cliente"
                        v.memory = 1024
                        v.cpus = 1
                end
        end

end