# Vagrant

- [Vagrant](#vagrant)
  - [Virtualization](#virtualization)
  - [What is vagrant](#what-is-vagrant)
  - [Installing Vagrant](#installing-vagrant)
  - [vagrant init - Initialize Vagrantfile](#vagrant-init---initialize-vagrantfile)
  - [vagrant up - Start virtual machine](#vagrant-up---start-virtual-machine)
  - [vagrant ssh - Connect to vm via ssh](#vagrant-ssh---connect-to-vm-via-ssh)
  - [/vagrant - Shared directory](#vagrant---shared-directory)
  - [Add another shared directory to VM](#add-another-shared-directory-to-vm)
  - [vagrant reload - Restarts VM applying any changes made to Vagrantfile](#vagrant-reload---restarts-vm-applying-any-changes-made-to-vagrantfile)
  - [Vagrant network configuration](#vagrant-network-configuration)
  - [vagrant suspend - Machine state is saved but machine is stopped](#vagrant-suspend---machine-state-is-saved-but-machine-is-stopped)
  - [vagrant resume - Machine is started with previously saved state](#vagrant-resume---machine-is-started-with-previously-saved-state)
  - [vagrant halt - Shutdown machine](#vagrant-halt---shutdown-machine)
  - [vagrant destroy - Resets machine to factory settings](#vagrant-destroy---resets-machine-to-factory-settings)
  - [Running shell script commands on VM to provision it](#running-shell-script-commands-on-vm-to-provision-it)
  - [vagrant provision - Provision already created vagrant VM](#vagrant-provision---provision-already-created-vagrant-vm)
  - [Create and provision multiple VM's in one Vagrantfile](#create-and-provision-multiple-vms-in-one-vagrantfile)
  - [vagrant status - Get status of VM's in current directory](#vagrant-status---get-status-of-vms-in-current-directory)

## Virtualization

Virtualization simply refers to abstracting the hardware components of
a machine so that it can operate multiple "virtual machines" sharing
its own resources

## What is vagrant

Vagrant is one of the DevOps tools that helps automate infrastructure
provisioning. It works on top of one of the virtualization platforms
like VirtualBox and VMWare.
Vagrant offers instant provisioning.

Ex: You want to deploy the LAMP stack (Linux Apache MySQL PHP)
on a virtual machine running Ubuntu.
The typical workflow for such a task would be as follows:

- Download Ubuntu ISO
- Configure virtual machine on VirtualBox, setup disk and mount the ISO file as a virtual CD-ROM
- Start the installation by following the wizard
- Perform post installation tasks like creating the necessary users and groups
- Download and configure Apache
- Download and deploy PHP and also configure the necessary Apache modules
- Download and install MySQL and perform the necessary security procedures

How can vagrant help?

- The previous procedure will take no less than 3 hours at best to complete
- A clever admin can write automation scripts that will speed things up
- Vagrant provides an already-built virtual machine
- You don't have to install or configure the OS since it's already done for you
- Vagrant uses boxes to provide the image for you
- A box is like a template containing everything needed to spawn an image
- Using a box, you can create as many machines as you need, all with the same configuration.
- This means multiple LAMP stack machines created within seconds instead of hours or even days.

## Installing Vagrant

First install a virtualization software like VirtualBox or VMWare

```bash
sudo apt install virtualbox

# Or
yum install VirtualBox
```

Next install Vagrant

```bash
sudo apt install vagrant

# Verify installation
vagrant --version
```

## vagrant init - Initialize Vagrantfile

Creates a text file in the current directory called a `Vagrantfile`.

It contains the information used to install a box.

Downloads the image if it hasn't already.

Find boxes at [https://vagrantcloud.com/search](https://vagrantcloud.com/search)

```bash
vagrant init repo/box-name

# Ex
vagrant init ubuntu/xenial64
```

## vagrant up - Start virtual machine

Starts the virtual machine defined by the Vagrantfile in the current directory.

Must be in a directory with a Vagrantfile for this command to work.

```bash
vagrant up [VM_NAME]
```

## vagrant ssh - Connect to vm via ssh

Establish an ssh connection between localhost and guest machine

```bash
vagrant ssh [VM_NAME]
```

## /vagrant - Shared directory

Can be used to share files between host and guest machines.

On the host machine, it is where the Vagrantfile is located.

On the guest machine it is in the path `/vagrant`

```bash
cd /vagrant
```

## Add another shared directory to VM

Add the following line to the Vagrantfile

```ruby
# The first argument is the path on the host to the actual folder.
# The second argument is the path on the guest to mount the folder.
config.vm.synced_folder "../data", "/vagrant_data"
```

Make sure to run the following command after making changes to the Vagrantfile:

```bash
vagrant reload
```

To disable all file sharing, use this line in the Vagrantfile:

```ruby
config.vm.synced_folder ".", "/vagrant", disabled: true
```

## vagrant reload - Restarts VM applying any changes made to Vagrantfile

```bash
vagrant reload [VM_NAME]
```

## Vagrant network configuration

Vagrant supports three modes of network access to the guest machine. Choose the one the best suits your needs:

- Port forwarding: this means that you'll access the guest network services through the host's IP address. Traffic arriving at the host's IP address and port will be forwarded to the guest network. For example, you can run a web server on the guest machine on port 80, and access it through the host's IP on port 8080.

- Private network: the guest will share an internal network with the host. It will have its own IP address but only the host and other guests running on the same host will access it.

- Public network: the gust will be fully accessible from the internal network as well externally. It will bear an IP address that can be reached the same way the host is reached on the network.

The above settings can be configured in the Vagrantfile:

```ruby
# Create a forwarded port mapping which allows access to a specific port
# within the machine from a port on the host machine. In the example below,
# accessing "localhost:8080" will access port 80 on the guest machine.
# NOTE: This will enable public access to the opened port
config.vm.network "forwarded_port", guest: 80, host: 8080
```

Make sure to reload vm afterwards:

```bash
vagrant reload
```

## vagrant suspend - Machine state is saved but machine is stopped

```bash
vagrant suspend [VM_NAME]
```

## vagrant resume - Machine is started with previously saved state

```bash
vagrant resume [VM_NAME]
```

## vagrant halt - Shutdown machine

```bash
vagrant halt [VM_NAME]

# Force shutdown if graceful shutdown doesn't work
vagrant halt --force
```

## vagrant destroy - Resets machine to factory settings

All changes made to this machine will be reset.

Only shared directory files are kept (`/vagrant`)

```bash
vagrant destroy [VM_NAME]
```

## Running shell script commands on VM to provision it

Add the following to the Vagrantfile:

```ruby
# Enable provisioning with a shell script. Additional provisioners such as
# Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
# documentation for more information about their specific syntax and use.
config.vm.provision "shell", inline: <<-SHELL
  apt-get update
  apt-get install -y apache2
SHELL
```

To use a local shell script that will be copied on the guest:

```ruby
config.vm.provision "shell", path: "deployLAMP.sh", privileged: false
```

Tools like Ansible, Chef, Puppet, Salt and Docker can also be used for provisioning

## vagrant provision - Provision already created vagrant VM

Once you have added provisioning config to your Vagrant file, run:

```bash
vagrant provision [VM_NAME]
```

## Create and provision multiple VM's in one Vagrantfile

```ruby
config.vm.define "app" do |app|
  app.vm.provision "shell", path: "deployWeb.sh", privileged: false
end

config.vm.define "db" do |db|
  db.vm.provision "shell", path: "deployDb.sh", privileged: false
end
```

## vagrant status - Get status of VM's in current directory

Omit `VM_NAME` to get the status of all machines.

```bash
vagrant status [VM_NAME]
```
