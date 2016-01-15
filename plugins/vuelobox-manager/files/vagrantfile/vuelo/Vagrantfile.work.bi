# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(2) do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.


  # Vagrant pre-configure
  # SSH username, private-key and other stuffs
  config.ssh.username = "serverpilot"

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.
  config.vm.box = "ubuntu/trusty64"

  # The url from where the 'config.vm.box' box will be fetched if it
  # doesn't already exist on the user's system.
  config.vm.box_url = "http://192.168.1.93/overnight/trusty64.box"

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  config.vm.network "forwarded_port", guest: 80, host: 80
  config.vm.network "forwarded_port", guest: 8080, host: 8080
  config.vm.network "forwarded_port", guest: 25, host: 25
  config.vm.network "forwarded_port", guest: 21, host: 21
  config.vm.network "forwarded_port", guest: 22, host: 22
  config.vm.network "forwarded_port", guest: 443, host: 443
  config.vm.network "forwarded_port", guest: 3360, host: 3360

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  config.vm.network "private_network", ip: "10.10.0.69"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  config.vm.network "public_network", ip: "192.168.0.253", bridge: "en0: Wi-Fi (AirPort)"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "./apps", "/srv/users/serverpilot/apps", type: "nfs"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  config.vm.provider "virtualbox" do |vb|
     # Setting another name for the machine
     vb.name = "vuelo_dev_machine"
     # Display the VirtualBox GUI when booting the machine
     vb.gui = false
     # vb.memory = "1024"
  
     # Customize the amount of memory & cpus on the VM
     host = RbConfig::CONFIG['host_os']
     # Give VM 1/4 system memory & access to all cpu cores on the host
     if host =~ /darwin/
       cpus = `sysctl -n hw.ncpu`.to_i
       # sysctl returns Bytes and we need to convert to MB
       mem = `sysctl -n hw.memsize`.to_i / 1024 / 1024 / 4
     elsif host =~ /linux/
       cpus = `nproc`.to_i
       # meminfo shows KB and we need to convert to MB
       mem = `grep 'MemTotal' /proc/meminfo | sed -e 's/MemTotal://' -e 's/ kB//'`.to_i / 1024 / 4
     else # sorry Windows folks, I can't help you
       cpus = 2
       mem = 1024
     end

     vb.customize ["modifyvm", :id, "--memory", mem]
     vb.customize ["modifyvm", :id, "--cpus", cpus]
  end

  #
  # View the documentation for the provider you are using for more
  # information on available options.

  # Define a Vagrant Push strategy for pushing to Atlas. Other push strategies
  # such as FTP and Heroku are also available. See the documentation at
  # https://docs.vagrantup.com/v2/push/atlas.html for more information.
  # config.push.define "atlas" do |push|
  #   push.app = "YOUR_ATLAS_USERNAME/YOUR_APPLICATION_NAME"
  # end

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
  # config.vm.provision "shell", inline: <<-SHELL
  #   sudo apt-get update
  #   sudo apt-get install -y apache2
  # SHELL
end