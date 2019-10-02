# Project

- [Project](#project)
  - [Project Map](#project-map)
  - [Tools that are used](#tools-that-are-used)
  - [Project files](#project-files)
  - [Startup project machines](#startup-project-machines)
  - [Installing jenkins](#installing-jenkins)
  - [Unit Tests](#unit-tests)
  - [Jenkins project](#jenkins-project)
  - [Integration Job](#integration-job)
  - [Continuous Delivery](#continuous-delivery)
  - [Continuous Deployment](#continuous-deployment)

## Project Map

The project is a web-based application.
It contains the following components.

| Environment | # of Machines | Purpose |
| ----------- | ------------- | ------- |
| Client      | 1                  | Mimics the developer machine used to write the application code. Also used for running Ansible against the other environments. |
| Testing     | 2                  | The application server hosting the web application and the database server hosting the backend database. |
| Production  | 2                  | The application server, the database server. |

## Tools that are used

**Vagrant** for infrastructure provisioning.

**Ansible** for configuration management

**Git** for version control, GitHub as a central repository.

**Jenkins** as a CI/CD tool.

## Project files

`application.yml`

```YAML
- hosts: all
  become: yes
  handlers:
    - name: restart Apache
      service:
        name: httpd
        state: restarted
  tasks:
    - name: Install git client
      yum:
        name: git
        state: present
    - name: Download and deploy Swift
      git:
        repo: https://github.com/abohmeed/swift
        dest: /var/www/html/CodeIgniter-3.1.5/
        clone: yes
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
      yum:
        name: https://mirrors.nic.cz/epel/7/x86_64/Packages/e/epel-release-7-11.noarch.rpm
        state: present
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
- hosts: all
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
    - name: Upload bookings.sql
      copy:
        src: bookings.sql
        dest: /tmp/bookings.sql
    - name: Import bookings.sql
      mysql_db:
        state: import
        name: all
        target: /tmp/bookings.sql
```

`Vagrantfile`

```ruby
# -*- mode: ruby -*-
# vi: set ft=ruby :

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
  config.vm.box = "centos/7"

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # NOTE: This will enable public access to the opened port
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine and only allow access
  # via 127.0.0.1 to disable public access
  # config.vm.network "forwarded_port", guest: 80, host: 8080, host_ip: "127.0.0.1"

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  # config.vm.provider "virtualbox" do |vb|
  #   # Display the VirtualBox GUI when booting the machine
  #   vb.gui = true
  #
  #   # Customize the amount of memory on the VM:
  #   vb.memory = "1024"
  # end
  #
  # View the documentation for the provider you are using for more
  # information on available options.

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
  # config.vm.provision "shell", inline: <<-SHELL
  #   apt-get update
  #   apt-get install -y apache2
  # SHELL
  
  config.vm.define "client" do |client|
    client.vm.hostname = "client"
    client.vm.network "private_network", ip: "192.168.33.10"
  end

  config.vm.define "web" do |web|
    web.vm.hostname = "apache"
    web.vm.network "private_network", ip: "192.168.33.20"
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
  
end

```

`bookings.sql`

```sql
CREATE TABLE IF NOT EXISTS ci_database.bookings (
`id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
name varchar(20) null,
email varchar(20) null,
passengers varchar(2) null,
departure date null
)ENGINE=innodb;
```

`htaccess`

```htaccess
RewriteEngine on
RewriteCond $1 !^(index\.php|resources|robots\.txt)
RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d
RewriteRule ^(.*)$ index.php/$1 [L,QSA]
```

`my.cnf`

```cnf
[client]
user=root
password=admin
```

`database.php`

```php
<?php
defined('BASEPATH') OR exit('No direct script access allowed');

/*
| -------------------------------------------------------------------
| DATABASE CONNECTIVITY SETTINGS
| -------------------------------------------------------------------
| This file will contain the settings needed to access your database.
|
| For complete instructions please consult the 'Database Connection'
| page of the User Guide.
|
| -------------------------------------------------------------------
| EXPLANATION OF VARIABLES
| -------------------------------------------------------------------
|
|	['dsn']      The full DSN string describe a connection to the database.
|	['hostname'] The hostname of your database server.
|	['username'] The username used to connect to the database
|	['password'] The password used to connect to the database
|	['database'] The name of the database you want to connect to
|	['dbdriver'] The database driver. e.g.: mysqli.
|			Currently supported:
|				 cubrid, ibase, mssql, mysql, mysqli, oci8,
|				 odbc, pdo, postgre, sqlite, sqlite3, sqlsrv
|	['dbprefix'] You can add an optional prefix, which will be added
|				 to the table name when using the  Query Builder class
|	['pconnect'] TRUE/FALSE - Whether to use a persistent connection
|	['db_debug'] TRUE/FALSE - Whether database errors should be displayed.
|	['cache_on'] TRUE/FALSE - Enables/disables query caching
|	['cachedir'] The path to the folder where cache files should be stored
|	['char_set'] The character set used in communicating with the database
|	['dbcollat'] The character collation used in communicating with the database
|				 NOTE: For MySQL and MySQLi databases, this setting is only used
| 				 as a backup if your server is running PHP < 5.2.3 or MySQL < 5.0.7
|				 (and in table creation queries made with DB Forge).
| 				 There is an incompatibility in PHP with mysql_real_escape_string() which
| 				 can make your site vulnerable to SQL injection if you are using a
| 				 multi-byte character set and are running versions lower than these.
| 				 Sites using Latin-1 or UTF-8 database character set and collation are unaffected.
|	['swap_pre'] A default table prefix that should be swapped with the dbprefix
|	['encrypt']  Whether or not to use an encrypted connection.
|
|			'mysql' (deprecated), 'sqlsrv' and 'pdo/sqlsrv' drivers accept TRUE/FALSE
|			'mysqli' and 'pdo/mysql' drivers accept an array with the following options:
|
|				'ssl_key'    - Path to the private key file
|				'ssl_cert'   - Path to the public key certificate file
|				'ssl_ca'     - Path to the certificate authority file
|				'ssl_capath' - Path to a directory containing trusted CA certificats in PEM format
|				'ssl_cipher' - List of *allowed* ciphers to be used for the encryption, separated by colons (':')
|				'ssl_verify' - TRUE/FALSE; Whether verify the server certificate or not ('mysqli' only)
|
|	['compress'] Whether or not to use client compression (MySQL only)
|	['stricton'] TRUE/FALSE - forces 'Strict Mode' connections
|							- good for ensuring strict SQL while developing
|	['ssl_options']	Used to set various SSL options that can be used when making SSL connections.
|	['failover'] array - A array with 0 or more data for connections if the main should fail.
|	['save_queries'] TRUE/FALSE - Whether to "save" all executed queries.
| 				NOTE: Disabling this will also effectively disable both
| 				$this->db->last_query() and profiling of DB queries.
| 				When you run a query, with this setting set to TRUE (default),
| 				CodeIgniter will store the SQL statement for debugging purposes.
| 				However, this may cause high memory usage, especially if you run
| 				a lot of SQL queries ... disable this to avoid that problem.
|
| The $active_group variable lets you choose which connection group to
| make active.  By default there is only one group (the 'default' group).
|
| The $query_builder variables lets you determine whether or not to load
| the query builder class.
*/
$active_group = 'default';
$query_builder = TRUE;

$db['default'] = array(
	'dsn'	=> '',
	'hostname' => '192.168.33.30',
	'username' => 'ci_user',
	'password' => 'cipassword',
	'database' => 'ci_database',
	'dbdriver' => 'mysqli',
	'dbprefix' => '',
	'pconnect' => FALSE,
	'db_debug' => (ENVIRONMENT !== 'production'),
	'cache_on' => FALSE,
	'cachedir' => '',
	'char_set' => 'utf8',
	'dbcollat' => 'utf8_general_ci',
	'swap_pre' => '',
	'encrypt' => FALSE,
	'compress' => FALSE,
	'stricton' => FALSE,
	'failover' => array(),
	'save_queries' => TRUE
);
```

## Startup project machines

Launch and provision the vagrant vm's.

```bash
vagrant up
```

Test that web app can be reached

```bash
# You may have to disable selinux
sudo setenforce 0;

curl 192.168.33.20
```

## Installing jenkins

Create `jenkins.yml`

```YAML
- hosts: all
  become: yes
  tasks:
    - name: Install repo key
      apt_key:
        url: https://pkg.jenkins.io/debian/jenkins-ci.org.key
        state: present
    - name: Add the Jenkins repository
      apt_repository:
        repo: 'deb https://pkg.jenkins.io/debian-stable binary/'
        state: present
    - name: Install Java
      apt:
        name: default-jre
        state: present
    - name: Install Jenkins
      apt:
        name: jenkins
        state: present
        update_cache: yes
    - name: Start and enable the Jenkins service
      service:
        name: jenkins
        state: started
        enabled: yes
    - name: Install required packages
      apt:
        name: [
            git,
            phpunit
        ]
        state: present
```

Add the following to your `Vagrantfile`

```ruby
config.vm.define "jenkins" do |jenkins|
  jenkins.vm.box = "ubuntu/xenial64"
  jenkins.vm.hostname = "jenkins"
  jenkins.vm.network "private_network", ip: "192.168.33.40"
  jenkins.vm.provision "ansible" do |ansible|
    ansible.playbook = "jenkins.yml"
  end
end
```

Then run

```bash
vagrant up jenkins
```

And test in command line and browser:

```bash
curl 192.168.33.40:8080
```

In the `Manage Plugins` section of Jenkins, Install the following plugins:

```plugins
GitHub
SSH
```

## Unit Tests

Login to the `client` machine:

```bash
vagrant ssh client
```

Then clone the repo:

```bash
# Make sure git is installed
sudo yum -y install git

# You may want to fork this repo and then clone your version
git clone https://github.com/abohmeed/swift.git

cd swift/
```

In our example, we will use the CodeIgniter PHPUnit test framework
[https://github.com/kenjis/ci-phpunit-test](https://github.com/kenjis/ci-phpunit-test).

The required files can be already found at `application/tests/`

```bash
cd application/tests/

cd controllers/

# To see an example unit test
vi Welcome_test.php

cd ../../../

# Create new git branches
git checkout -b feature
git checkout -b integration

# View branches
git branch

git checkout feature

git push --set-upstream origin feature

git checkout integration

git push --set-upstream origin integration

git checkout feature
```

Modify the page `vi application/views/welcome_message.php`:

```html
<!-- just add 1 option -->
<!-- ... -->
<select class="form-control" name="passengers" id="passengers">
    <option>1</option>
    <option>2</option>
    <option>3</option>
    <option>4</option>
    <option>5</option> <!-- <=== This one -->
</select>
<!-- ... -->

```

Push changes:

```bash
git checkout feature

git add *

git commit -m "Added a fifth passenger option"

git push
```

Exit vm and go to jenkins vm:

```bash
logout

vagrant ssh jenkins
```

Test phpunit

```bash
phpunit --version
```

Clone app in jenkins vm:

```bash
git clone https://github.com/JonathanDC64/swift-1.git
```

Run phpunit:

```bash
cd swift-1/application/tests/

# if phpunit gives you an error, try installing this
sudo apt-get install php7.0-mysql

phpunit
```

Go back to the client machine:

```bash
logout

vagrant ssh client
```

Make a destructive change:

```bash
vi swift-1/application/controllers/Welcome.php

# remove semicolon ; from this line:
# $data['name'] = $this->input->post("username"); => $data['name'] = $this->input->post("username")

cd swift-1/

git checkout feature
git add *
git commit -m "Broke homepage"
git push

logout

vagrant ssh jenkins
rm -rf swift-1/

git clone https://github.com/JonathanDC64/swift-1.git

cd swift-1/

git checkout feature

git pull

cd application/tests/

# You should notice an error because of the semicolon ; you removed
phpunit

logout

vagrant ssh client

cd swift-1/

# Put back the semicolon ;
vim application/controllers/Welcome.php

git add *

git commit -m "Fixed the homepage"

logout

vagrant ssh jenkins

cd swift-1/

git pull

cd application/tests/

# Run tests again to see no errors
phpunit
```

Unit tests are used for testing small and functional parts of your application.

## Jenkins project

Create a new item on jenkins called `swift_feature_test`

In Source Code Management, select `Git`
and paste your repository url

In the `Branch to build` section of Git, use the `*/feature` branch.

Under Build Triggers, select `Poll SCM` with schedule `0 * * * *`.

Under `Build` add build step `Execute shell` and for the command, put:

```bash
cd application/tests
phpunit
```

Jenkins will recognize a failed exit code of a shell command.

This means that if the unit test fails, Jenkins will consider the build as failed as well.

Go back to the dashboard and start the job.

Ensure that the job finishes successfully.

## Integration Job

We will make use of continuous integration.

Whenever the code passes successfully the phpunit tests,
its going to get integrated to the `integration` branch of our project.

It will also be pushed to the GitHub repositories `integration` branch.

First create a Jenkins project called `swift_feature_integration`.

Select `Git` under `Source Code Management`,
paste your repository url and select the `*/feature` branch.
Also, Add your github credentials.

Under `Build Triggers` select `Build after other projects are built`,
add `swift_feature_test` under `Projects to watch`.

Under `Build` select `Execute shell` and add the command:

```bash
cd application/tests/
phpunit
```

Under `Post-Build Actions`, select `Git Publisher`
and select `Push Only If Build Succeeds`.
Add branch, then select `integration` for `Branch to push`
and `origin` for `Target remote name`.

Add another `Build` step for `Execute shell` with command:

```bash
git checkout feature
git pull
git checkout integration
git merge feature
```

This shell script will only run if the previous one, with the unit test, succeeds.

Click on Save.

Login to the client machine and edit a view.

```bash
vagrant ssh client
cd swift-1/

# Remove <option>5</option>
vim application/views/welcome_message.php

git add *
git commit -m "Removed option 5"
git push
```

Go back to Jenkins and run the `swift_feature_test` Job.

## Continuous Delivery

We will make an identical environment to our production web server
but for our development server.

Edit the Vagrant file, add:

```ruby
config.vm.define "webdev" do |webdev|
  webdev.vm.hostname = "apachedev"
  webdev.vm.network "private_network", ip: "192.168.33.25"
  webdev.vm.provision "ansible" do |ansible|
    ansible.playbook = "application.yml"
  end
end
```

Startup the machine:

```bash
vagrant up webdev
```

Try to load the page in your browser at `192.168.33.25`.
If you see a test page, you may need to disable selinux with this command:

```bash
vagrant ssg webdev
sudo setenforce 0;
```

We have now created a testing environment identical to the production environment.

Go to Jenkins and create a job called `swift_feature_delivery`

Add the Git repository under `Source Code Management`, No need for credentials.
Use `*/integration` branch.

Under `Build Triggers`, select `Build after other projects are built`,
and under `Project to watch` select `swift_feature_integration`.

Under `Build` select `Execute shell script on remote host using ssh`.

Save the project for now and go to `Manage Jenkins` => `Configure System`.

Under `SSH remote hosts` add both `web` and `webdev` ssh information.
Make sure to add credentials as username: `vagrant` and password: `vagrant`.

Go back to the configure page of the `swift_feature_delivery` job

Back under `Build` select `Execute shell script on remote host using ssh`
and add the command:

```bash
cd /var/www/html/CodeIgniter-3.1.5/
git checkout integration
git pull
```

Save Job.

Login to client machine and make modification:

```bash
vagrant ssh client

cd swift-1/

# Change title to <title>Hello to Swift</title>
vim application/views/welcome_message.php

git add *
git commit -m "changed title of the homepage"
git push
```

Return to Jenkins and run `swift_feature_test`

## Continuous Deployment

This step will integrate changes to the master branch, and deploy them to the production server.

In Jenkins create a new jon called `swift_feature_master_integration`

Again under Git add your repository and credentials.

For the branch you will use `*/integration` this time.

Under `build triggers` and `Build after other projects are built`,
select `swift_feature_delivery`.

Under `Build` select `Execute shell` with command

```bash
cd application/tests
phpunit
```

Add another with:

```bash
git checkout integration
git pull
git checkout master
git merge integration
```

Under `Post-build actions` select `Git publisher`
and check `Push Only if Build Succeeds`.
Select the `Branch to push` to `master` and `Target remote name` to `origin`

Save the job and run `swift_feature_test`.

Now we will create a new Job that will deploy the master branch code to the production server.

Create a new job called `swift_deployment`, Choose copy from `swift_feature_delivery`.

Change branch from `*/integration` to `*/master`.

Change `project to watch` to `swift_feature_master_integration`

Change the `Execute shell script on remote host using ssh`
with SSH site `vagrant@192.168.33.20:22`, the production server.

Click Save and run job `swift_feature_test`.

Open the webpage for the production server at `192.168.33.20`

Check if the changes show up.
