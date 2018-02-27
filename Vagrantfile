# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrant init uses double quotes so makes sense to ignore it in rubocop
# rubocop:disable StringLiterals

# Confirm the host port to bind to. The default of 6379 is used if the env var
# is not set, but this allows us to be flexible (for example where a port
# conflict occurs)
host_port = ENV["MONGODB36_HOST_PORT"] || 27_017
project_name = "mongodb-36-box"

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://vagrantcloud.com/search.
  config.vm.box = "ubuntu/xenial64"
  config.vm.hostname = project_name

  if Vagrant.has_plugin?("vagrant-cachier")
    # Configure cached packages to be shared between instances of the same base
    # box. More info on the "Usage" link above
    config.cache.scope = :box

    # Workaround to prevent `Can't drop privileges for downloading as file`
    # https://github.com/fgrehm/vagrant-cachier/issues/175#issuecomment-233507989
    config.cache.synced_folder_opts = {
      owner: '_apt',
      group: '_apt',
      mount_options: %w[dmode=777 fmode=666]
    }
  end

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  config.vm.provider "virtualbox" do |vb|
    vb.name = project_name
    # Needed to upgrade the amount of memory else was getting errors during the
    # install
    # vb.memory = "1024"
  end

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine.
  config.vm.network "forwarded_port", guest: 27_017, host: host_port

  # General provisioning of the box. Ensure time is set correctly and do an
  # initial apt-get update, plus install packages commonly needed by all boxes
  config.vm.provision "shell", name: "common", inline: <<-SHELL
    timedatectl set-timezone Europe/London
    apt-get update > /dev/null
  SHELL

  # Specific provisioning of the box
  config.vm.provision "shell", name: "mongodb", path: "buildsteps/mongodb.sh"
end

# rubocop:enable StringLiterals
