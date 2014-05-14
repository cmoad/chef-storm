# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.require_version ">= 1.5.0"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # Prevent the "stdin: is not a tty" warning
  config.ssh.shell = "bash -c 'BASH_ENV=/etc/profile exec bash'"

  config.vm.hostname = "vagrant-storm"

  # Set the version of chef to install using the vagrant-omnibus plugin
  config.omnibus.chef_version = :latest

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "opscode_ubuntu-12.04_provisionerless"

  # The url from where the 'config.vm.box' box will be fetched if it
  # doesn't already exist on the user's system.
  config.vm.box_url = "https://opscode-vm-bento.s3.amazonaws.com/vagrant/opscode_ubuntu-12.04_provisionerless.box"

  config.berkshelf.enabled = true

  config.vm.provider :virtualbox do |vb|
    # Options for only when using the VirtualBox provider
    vb.customize ['modifyvm', :id, "--natdnshostresolver1", "on"]
  end

  config.vm.provision :shell do |shell|
    shell.inline = 'test -f $1 || (sudo apt-get update -y && touch $1)'
    shell.args = '/var/run/apt-get-update'
  end

  config.vm.provision :chef_solo do |chef|
    chef.json = {
        :exhibitor => {
            :opts => {
                :port => "8000"
            }
        }
    }

    chef.run_list = [
        "recipe[zookeeper]",
        "recipe[storm::nimbus]",
        "recipe[storm::supervisor]"
    ]
  end
end
