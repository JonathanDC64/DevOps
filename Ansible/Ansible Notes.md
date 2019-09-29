# Ansible

- [Ansible](#ansible)
  - [Why configuration management is needed](#why-configuration-management-is-needed)
  - [What is Ansible](#what-is-ansible)
  - [Installing Ansible](#installing-ansible)
  - [The Inventory file](#the-inventory-file)
  - [Using private key and public key to connect to other machines](#using-private-key-and-public-key-to-connect-to-other-machines)
  - [Ansible basics](#ansible-basics)
  - [The YAML Format](#the-yaml-format)
  - [Ansible YAML Playbook](#ansible-yaml-playbook)
  - [Ansible Lab : LAMP stack](#ansible-lab--lamp-stack)
  - [Provisioning using Ansible from the Vagrantfile](#provisioning-using-ansible-from-the-vagrantfile)

## Why configuration management is needed

To achieve a DevOps environment, automation is needed.

Having applications containerized using Docker is one option of "Instant Provisioning".
But it's not the only one and it's not suitable for all cases.

For those who require Vagrant as an infrastructure-provisioning tool,
there should be a way to deploy or customize an application.

So, you can find a Vagrant box with Apache installed.
But what if you want an Nginx reverse proxy installed on top of that?
Or, what if you need some custom users and groups configured, together with some file permissions?

Shell scripting is an option and it is supported by Vagrant to boot up and configure
the machine automatically (instant provisioning).
But this may not be your best choice and here's why:

Shell scripts are great. The Bash shell, for example has a huge set of commands
and functions to automate any  task.

But when it comes to DevOps, a shell script will not offer the following:

1._Change management documentation_: there needs to be a way to document
even the slightest change done to a system. This will save you endless hours
trying to figure out what went wrong after a series of changes occurred.
You can comment your shell script, but still that is not enough as
we'll see later.

2._Idempotence_: this refers to the ability to run an operation several times
with the same result each time.
This is very difficult to be done with a shell script.

## What is Ansible

It is one of the DevOps tools concerned with configuration management.
It's not the only one in the market as there are other tools like
Chef, Puppet and Salt.

Basically, they all do the same thing. But Ansible has some strength points:

1. It's agent-less. no extra software needs to be installed on the target machine
2. It uses Python for instructions. Python is one of the most popular scripting languages out there. It's more likely to be under the tool belt of a typical system administrator.
3. It uses SSH for connecting to the remote servers. SSH is an industry standard security protocol that all system administrators are familiar with.

## Installing Ansible

Can be done through the OS package manager and through pip.

On Ubuntu:

```bash
sudo apt update
sudo apt install software-properties-common
sudo apt-add-repository --yes --update ppa:ansible/ansible
sudo apt install ansible
```

On CentOS

```bash
sudo yum install epel-release
sudo yum -y install ansible
```

With Python pip:

```bash
sudo easy_install pip
sudo pip install ansible
```

Verify installation:

```bash
ansible --version
```

## The Inventory file

Ansible uses `/etc/ansible/hosts` file to know about which machines
you want configured by Ansible.

This file contains machine host names, IP addresses, or a mix of them.
This depends on how the client machine (the one with Ansible installed)
can communicate with target hosts.

Hosts can be added either in named groups for easier reference, or as
standalone entries.

If you have a number of hosts for which you chose a numbered naming pattern
(like web1, web2, web3 ... web6), you can add them on one line like web[1..6]

`/etc/ansible/hosts` Example:

```ansible
# It should live in /etc/ansible/hosts
#
#   - Comments begin with the '#' character
#   - Blank lines are ignored
#   - Groups of hosts are delimited by [header] elements
#   - You can enter hostnames or ip addresses
#   - A hostname/ip can be a member of multiple groups

# Ex 1: Ungrouped hosts, specify before any group headers.

## green.example.com
## blue.example.com
## 192.168.100.1
## 192.168.100.10

# Ex 2: A collection of hosts belonging to the 'webservers' group

## [webservers]
## alpha.example.org
## beta.example.org
## 192.168.1.100
## 192.168.1.110

# If you have multiple hosts following a pattern you can specify
# them like this:

## www[001:006].example.com

# Ex 3: A collection of database servers in the 'dbservers' group

## [dbservers]
##
## db01.intranet.mydomain.net
## db02.intranet.mydomain.net
## 10.25.1.56
## 10.25.1.57

# Here's another example of host ranges, this time there are no
# leading 0s:

## db-[99:101]-node.example.com
```

If your using Vagrant, you have to set the network settings in the Vagrantfile.

You can then give that IP a host name in `/etc/hosts` which you can then
add to and refer to in `/etc/ansible/hosts`

`/etc/hosts` Example:

```bash
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
192.168.33.20 ubuntu # This entry was added
```

## Using private key and public key to connect to other machines

Suppose you have 2 machines:

Ubuntu: 192.168.33.20

CentOS: 192.168.33.10

```bash
ssh-keygen
# Generating public/private rsa key pair.
# Enter file in which to save the key (/home/vagrant/.ssh/id_rsa):
# Enter passphrase (empty for no passphrase):
# Enter same passphrase again:
# Your identification has been saved in /home/vagrant/.ssh/id_rsa.
# Your public key has been saved in /home/vagrant/.ssh/id_rsa.pub.
# The key fingerprint is:
# SHA256:7KAOTerNkHOskoLErla9tBjnBn+B+RZ0KbbMjRsPHpM # vagrant@localhost.localdomain
# The key's randomart image is:
# +---[RSA 2048]----+
# |                 |
# |                 |
# |          .      |
# |       = o       |
# |.   o O S        |
# | o X B E .       |
# |+.B & = @        |
# |=+ @ * * .       |
# |=.o = o          |
# +----[SHA256]-----+

# You may have to enable Password Authentication on the machine you wish to connect to
# If you don't, you may get a permission denied (public key) error
# Open (sudo) nano /etc/ssh/sshd_config
# change:
# PubKeyAuthentication Yes
# #PasswordAuthentication no
# To
# PubKeyAuthentication No
# PasswordAuthentication Yes
# Then:
# $ systemctl restart sshd
# $ service sshd restart

sudo ssh-copy-id -i /home/vagrant/.ssh/id_rsa.pub vagrant@ubuntu

# You can also copy the contents of your public key and append into the ~/.ssh/authorized_keys of your target machine


# Now edit the sudoers file on the target machine, the `vagrant` user is already part of sudoers 
sudo visudo

# Being in the list of sudoers, you can make it so that you don't have to input your password.
```

## Ansible basics

`MACHINE_NAME` can also be a group name.

`-a` Execute commands on the target machines command line

```bash
ansible MACHINE_NAME -a COMMAND

# Ex:
ansible ubuntu -a "bash --version"
```

## The YAML Format

YAML is short for YAML Ain't Markup Language.
It is used the same as JSON files:
to serialize data in an easy format that is readable by both humans and machines.

Data is stored in key/value pairs separated by colons.
Items can be grouped if they have the same indentation level.

Arrays (called dictionaries) of data are represented by placing a dash before each item.
Of course all items in an array should be on the same indentation level.

Quoting values is optional, but it is mandatory if you are using special characters (like colons)
in the values.

**YAML does not allow you to use tabs for indentation. Only spaces are allowed.**

Sample YAML file:

```YAML
--- !clarkevans.com/^invoice
invoice: 34843
date   : 2001-01-23
bill-to: &id001
    given  : Chris
    family : Dumars
    address:
        lines: |
            458 Walkman Dr.
            Suite #292
        city    : Royal Oak
        state   : MI
        postal  : 48046
ship-to: *id001
product:
    - sku         : BL394D
      quantity    : 4
      description : Basketball
      price       : 450.00
    - sku         : BL4438H
      quantity    : 1
      description : Super Hoop
      price       : 2392.00
```

## Ansible YAML Playbook

We are going to make an Ansible playbook that installs apache on the target machines.

Ansible server will be the CentOS machine.

Target machine will be the Ubuntu machine with the hostname `ubuntu`.

Here is the YAML file contents containing the instructions for our Ansible playbook.

webserver.yml

```YAML
- hosts: ubuntu # Which hosts Ansible will contact, `all` means all machines in the hosts file
  become: yes # Use root (sudo) privileges
  tasks: # List of tasks to execute on the remote machine
    - name: Ensure that apache is installed # Descriptive name for the task
      apt: # Uses apt-get on ubuntu machines (yum for centos)
        name: apache2 # Package name (httpd for centos)
        state: present # If present, install it. Can also use `absent` to ensure that it is not installed (remove it)
    - name: Ensure that Apache is running and will be started on boot
      service: # Handles the daemons that are running on the remote systems
        name: apache2 # Service name
        state: started # started/stopped/restarted
        enabled: yes # Ensure that service is started whenever the system is booted
```

Running the playbook

```bash
ansible-playbook PLAYBOOK_FILE

# Ex:
ansible-playbook webserver.yml


# PLAY [ubuntu] ****************************************************************************************************************************************

# TASK [Gathering Facts] *******************************************************************************************************************************
# ok: [ubuntu]
#
# TASK [Ensure that apache is installed] ***************************************************************************************************************
#  [WARNING]: Updating cache and auto-installing missing dependency: python-apt
#
#  [WARNING]: Could not find aptitude. Using apt-get instead
#
# changed: [ubuntu]
#
# TASK [Ensure that Apache is running and will be started on boot] *****************************************************************************
# ok: [ubuntu]
#
# PLAY RECAP *********************************************************************************************************************************
# ubuntu                     : ok=3    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0


# you can now try to ssh into ubuntu and `curl localhost` to see if apache is serving the default page
```

## Ansible Lab : LAMP stack

We are going to first create a CentOS vagrant VM in a folder called `lamp`.

```bash
vagrant init centos/7
```

Edit the Vagrantfile and add:

```ruby
config.vm.define "client" do |client|
  client.vm.hostname = "client"
  client.vm.network "private_network", ip: "192.168.33.10"
end

config.vm.define "web" do |web|
  web.vm.hostname = "apache"
  web.vm.network "private_network", ip: "192.168.33.20"
  web.vm.network "forwarded_port", guest: 80, host: 8080
end

config.vm.define "db" do |db|
  db.vm.hostname = "mysql"
  db.vm.network "private_network", ip: "192.168.33.30"
end
```

Now vagrant ssh into the `client` machine:

```bash
vagrant ssh client
```

And install Ansible as we did once before:

```bash
sudo yum install epel-release
sudo yum -y install ansible
```

Add the ip addresses of the target machines to the hosts file.

`sudo vi /etc/hosts`  and add:

```text
192.168.33.20   apache
192.168.33.30   mysql
```

Add those entries to your `/etc/ansible/hosts` file.

`sudo vi /etc/ansible/hosts` and add the groups:

```text
[webservers]
apache

[databases]
mysql
```

Generate a ssh private key and public key:

```bash
ssh-keygen
# Generating public/private rsa key pair.
# Enter file in which to save the key (/home/vagrant/.ssh/id_rsa):
# Enter passphrase (empty for no passphrase):
# Enter same passphrase again:
# Your identification has been saved in /home/vagrant/.ssh/id_rsa.
# Your public key has been saved in /home/vagrant/.ssh/id_rsa.pub.
# The key fingerprint is:
# SHA256:qDZ/m/lvXQ8/GnQZ84se0Du142QMFmf4SL9dTMgC1Jw vagrant@client
# The key's randomart image is:
# +---[RSA 2048]----+
# |         .oo .   |
# |           .E... |
# |            .+o=.|
# |       .    o.Bo=|
# |      . S  . * *+|
# |     .      + O B|
# |    +        B %o|
# |   . o  .o  o O.+|
# |      ..+o.o.o...|
```

Copy the contents of `~/.ssh/id_rsa.pub` into your target machines `~/.ssh/authorized_keys` file.

Note: You may get permission denied if you try to ssh directly from the `client` vm.
Try exiting the vm and ssh into the others with `vagrant ssh`.

```bash
cat ~/.ssh/id_rsa.pub
#ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDFB9cD6BDeG7V4wP4sOYeduYZSgZsudj7/nCeFLEGHJq9DAnlbGsIwg+v8SnGC7DMrw+fEYpWF98YI2a9z4wdiGUhn/OhR/3DHnshdJAon5iVStXjDlxStC1nICmWLClxYeaePZtk69jySd7yQ1s/4DMbduXXZVWEFIfk9XGB1Kg3ik5ZQFzXuRldS7xQAML9oNXSbBsbo6t3XdsuOQ1nkGYcpXojglEFdXCEz8r3sc+XbGKwl3EvA3aCfcxwjZJ5arnRMaJpL+g0Tg0Nna6hIVnxEzttOnliHm+BJ4dAnywtKqN9RIhtMqqFp22vuuPGZMVLb6lTn5kKo5j1D74+J vagrant@client

exit

vagrant ssh web

# Paste key into this file
sudo vi ~/.ssh/authorized_keys

exit

vagrant ssh db

# Paste key into this file
sudo vi ~/.ssh/authorized_keys

exit

vagrant ssh client

```

Ensure that you can ssh into `apache` and `mysql` without a password from `client`

```bash
ssh apache
exit
ssh mysql
exit
```

Test an ansible command:

```bash
ansible all -a "cat /etc/hosts"
# apache | CHANGED | rc=0 >>
# 127.0.0.1       apache  apache
# 127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
# ::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
#
# mysql | CHANGED | rc=0 >>
# 127.0.0.1       mysql   mysql
# 127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
# ::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
```

Create a playbook `application.yml`:

```YAML
- hosts: webservers
  become: yes
  handlers:
    - name: restart Apache
      service:
        name: httpd
        state: restarted
  tasks:
    - name: Install the Apache web server
      yum: 
        name: httpd
        state: present
    - name: Ensure that Apache is started and enabled on system boot
      service:
          name: httpd
          state: started
          enabled: yes
    - name: Add EPEL repository
      yum_repository: 
        name: epel
        description: EPEL YUM repo
        baseurl: https://download.fedoraproject.org/pub/epel/$releasever/$basearch/
    - name: Add public key of EPEL
      rpm_key: 
        state: present
        key: https://archive.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-7
    - name: Add Webtatic repository
      yum: 
        name: https://mirror.webtatic.com/yum/el7/webtatic-release.rpm
        state: present
    - name: Install PHP 7 and some required packages
      yum:
        name: [
          'mod_php71w',
          'php71w-cli',
          'php71w-common',
          'php71w-gd',
          'php71w-mbstring',
          'php71w-mcrypt',
          'php71w-mysqlnd',
          'php71w-xml',
          'unzip',
          'vim',
          'mariadb'
        ]
        state: present
    - name: Download and extract the CodeIgniter archive to /var/www/html
      unarchive:
        src: https://github.com/bcit-ci/CodeIgniter/archive/3.1.5.zip
        dest: /var/www/html
        remote_src: yes
    - name: Chane the files ownership to be owned by vagrant
      file:
        path: /var/www/html
        owner: vagrant
        group: vagrant
        recurse: yes
    - name: Change the web home directory to point at /var/www/html/CodeIgniter-3.1.5
      lineinfile: 
        path: /etc/httpd/conf/httpd.conf
        regexp: '^.*DocumentRoot "/var/www/html".*$'
        line: 'DocumentRoot "/var/www/html/CodeIgniter-3.1.5"'
        state: present
      notify:
        - restart Apache
    - name: Ensure that mod_rewrite is enabled in Apache
      lineinfile:
        path: /etc/httpd/conf.modules.d/00-base.conf
        regexp: '^.*rewrite_module.*$'
        line: 'LoadModule rewrite_module modules/mod_rewrite.so'
        state: present
    - name: Copy htaccess file to CodeIgniter
      copy:
        src: htaccess
        dest: /var/www/html/CodeIgniter-3.1.5/.htaccess
        owner: vagrant
        group: vagrant
    - name: Allow .htaccess file to be used
      lineinfile:
        path: /etc/httpd/conf/httpd.conf
        insertafter: '</Directory>'
        line: |
          <Directory "/var/www/html/CodeIgniter-3.1.5">
            AllowOverride all
          </Directory>
      notify:
        - restart Apache
    - name: Upload the database.php file
      copy:
        src: database.php
        dest: /var/www/html/CodeIgniter-3.1.5/application/config/database.php
        owner: vagrant
        group: vagrant
```

`database.yml`

```YAML
- hosts: databases
  become: yes
  tasks:
    - name: Ensure that MariaDB is installed
      yum:
        name: [
          mariadb-server,
          MySQL-python,
        ]
        state: present
    - name: Ensure that Mariadb is started and enabled
      service:
        name: mariadb
        state: started
        enabled: yes
    - name: Set the root password for MySQL
      mysql_user: # Requires MySQL-python package
        name: root
        password: admin
        state: present
    - name: Upload the .my.cnf file to save the credentials
      copy:
        src: my.cnf
        dest: /root/.my.cnf
        owner: root
        mode: 0600
    - name: Remove anonymous accounts
      mysql_user:
        name: ''
        host_all: yes
        state: absent
    - name: Create application database
      mysql_db:
        name: ci_database
        state: present
    - name: Create an application user
      mysql_user:
        name: ci_user
        password: cipassword
        host: '%'
        priv: ci_database.*:ALL
        state: present
```

Test it on on `client`:

```bash
ansible-playbook /vagrant/application.yml
ansible-playbook /vagrant/database.yml

curl localhost:8080
```

## Provisioning using Ansible from the Vagrantfile

`vagrant destroy` the `web` and `db` vm's.

Set `- hosts: all` in both `application.yml` and `database.yml`

Modify this section of the Vagrantfile:

```ruby
config.vm.define "client" do |client|
  client.vm.hostname = "client"
  client.vm.network "private_network", ip: "192.168.33.10"
  client.vm.synced_folder ".", "/vagrant", type: "virtualbox"
end

config.vm.define "web" do |web|
  web.vm.hostname = "apache"
  web.vm.network "private_network", ip: "192.168.33.20"
  web.vm.network "forwarded_port", guest: 80, host: 8080
  web.vm.provision "ansible" do |ansible|
    ansible.playbook = "application.yml"
  end
end

config.vm.define "db" do |db|
  db.vm.hostname = "mysql"
  db.vm.network "private_network", ip: "192.168.33.30"
  db.vm.provision "ansible" do |ansible|
    ansible.playbook = "database.yml"
  end
end
```

Run the command:

```bash
vagrant up
```