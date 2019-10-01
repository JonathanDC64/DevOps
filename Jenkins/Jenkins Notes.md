# Jenkins

- [Jenkins](#jenkins)
  - [The need for continuous integration](#the-need-for-continuous-integration)
  - [What does CI offer](#what-does-ci-offer)
  - [Continuous Integration, Delivery, Deployment, Whats the difference](#continuous-integration-delivery-deployment-whats-the-difference)
  - [Requirements and best Practices for CI/CD](#requirements-and-best-practices-for-cicd)
  - [Jenkins Installation](#jenkins-installation)
  - [Jenkins in action](#jenkins-in-action)
  - [Jenkins Dashboard](#jenkins-dashboard)

## The need for continuous integration

The best way to understand CI is to consider an example:

There is a class project that is a very basic and simple booking application.
It is a two-page app, one for taking the booking request and the other for
adding the record to the database and printing a confirmation to the user.
The simplicity here is for demonstration purposes.

A real-world booking application would be much more complicated than this.
It will have a module for handling requests, another for the billing, a third for
contacting the airline company's application and so on.

To develop an application like this, you need a team (or several teams) of developers,
all working simultaneously to finish the iteration.

Let's say developer A, B and C each grab a copy of the application source code
from the central repository.
These 3 developers are in completely isolated environments from each other.
Each one makes changes to the source code to fix a bug or add a new features.

Subsequently they push their changes to the master git repository to update the
application code.

If the 3 developers make several changes while unaware of what the other developers
have done, this can potentially cause errors in your application if these changes are
pushed to the master repository.

## What does CI offer

Using continuous integration, you ensure that every single unit of the application
being developed is tested the moment it is committed to the central repository.

If the application broke, behaved differently, or a bug was spotted, the responsible
person will be contacted to take the necessary action.

In CI, the application should not stay overnight in a non-stable state. This means that
any spotted bugs after the commit must be resolved as soon as possible.

This guarantees that:

- The time to fix bugs will be kept to a minimum as every minor failure will be solved
early enough before causing more severe bugs.

- Developers will always be able to pull a clean copy of the application from the
repository; as any failing code will not be allowed to be pushed to the central repository.

- Not human intervention exists in the operation. Special tools are designed for this
like **Jenkins** combined with a test framework like **PHPUnit**

When code is committed and tries to integrate with the master branch,
it will be prevented of doing so if any tests fail and thus will not be integrated.

**This is what Continuous integration is for.**

It protects code on the master branch from being integrated with code that causes errors.

## Continuous Integration, Delivery, Deployment, Whats the difference

**Continuous Integration (CI)**:
is the one with least concern (least risk) as it has the least automation.
CI stops when the committed code is tested and integrated successfully
to the master branch.

**Continuous Delivery**:
there is a little more automation here as it adds upon the work of CI
and delivers the application code from the master branch to the
non-production servers (instead of having to pull the changes manually
from the repository).
In other words:
It delivers your code to a testing (or staging) environment.

**Continuos Deployment**:
this is where full automation is achieved.
Code is deployed to be used as application code (or binary artifacts)
to the live production servers to be consumed by end users.
In other words:
Once all tests pass and code is considered 'bug free' it is
deployed to production

## Requirements and best Practices for CI/CD

CI/CD helps speed up software development iterations.
This not only helps finish the development process faster,
but will also make adding new features and fixing bugs much
more frequent. Major companies release new versions of their
application twice per month, while others will do the same
once per year or maybe more.

But just having a CI/CD tool in place is not enough.
Developers must make more commits that cover less changes.
That is, code the application in testable chunks and
write unit tests for every chunk.
Changes must be pushed at least once per day.

A revision control system must be used like Git.

A testing framework must be installed to run various types of automated
tests on the changes made in the code.

## Jenkins Installation

Jenkins is ine of the most easy-to-install DevOps tools.
It needs Java runtime environment as the only prerequisite.

It can be installed in 4 different ways:

**1. Using a Java container like Tomcat, WebLogic, WebSphere...etc.**

Tomcat Example:

```bash
# We will install Jenkins in a vagrant created VM
mkdir tomcat
cd tomcat/

vagrant init emessiha/ubuntu64-java

vi Vagrantfile
# Edit the Vagrantfile and add the line:
# config.vm.network "private_network", ip: "192.168.33.40"

vagrant up

# ssh into the newly created vm
vagrant ssh

# Download latest version of Jenkins War file
wget https://ftp-nyc.osuosl.org/pub/jenkins/war/latest/jenkins.war

# Copy into vagrant shared directory to use it in other installations
cp jenkins.war /vagrant/

# Deploy jenkins to tomcat
mv jenkins.war /opt/tomcat/webapps/

# Test to make sure tomcat server is reachable
curl 192.168.33.40:8080

# Access jenkins in your browser from 192.168.33.40:8080/jenkins
# It will ask you to enter a password
# It will say where the password is located on your machine
# Go to that location and copy paste it
# Ex: /home/ubuntu/.jenkins/secrets/initialAdminPassword
# Password may look like: 95148cba5d2a4cb09f61855340d9ea0b
# When it asks you about plugins, just click X on the top right
# You can install plugins later
# Then select 'Start Using Jenkins'
```

**2. Using the package manager.**

Ubuntu Example:

```bash
mkdir jenkins_ubuntu
cd jenkins_ubuntu/

vagrant init bento/ubuntu-16.10

vi Vagrantfile

# Add the following line to the Vagrantfile
# config.vm.network "private_network", ip: "192.168.33.50"

vagrant up
vagrant ssh

# Add repo key
wget -q -O - https://pkg.jenkins.io/debian/jenkins-ci.org.key | sudo apt-key add -

echo deb https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list

sudo apt-get update

sudo systemctl start jenkins

# Start on system boot
sudo systemctl enable jenkins

# Test
curl 192.168.33.50:8080

# Access jenkins in your browser from 192.168.33.40:8080/jenkins
# It will ask you to enter a password
# It will say where the password is located on your machine
# Go to that location and copy paste it
# Ex: /home/ubuntu/.jenkins/secrets/initialAdminPassword
# Password may look like: 95148cba5d2a4cb09f61855340d9ea0b
# When it asks you about plugins, just click X on the top right
# You can install plugins later
# Then select 'Start Using Jenkins'

```

**3. Using a Docker container.**

Docker Example:

```bash
# Pull docker image for jenkins
sudo docker pull jenkins

# Create a volume
mkdir jenkins_container
cd jenkins_container/

# Create docker container for jenkins ($PWD refers to the jenkins_container folder you created)
sudo docker run -d -p 8080:8080 -v $PWD:/var/jenkins_home jenkins

# Test to see if the jenkins sever is reachable
curl localhost:8080

# Open localhost:8080 in a browser
# It will ask you for a password
# It can be found in `secrets/initialAdminPassword` of your jenkins_container folder
cat secrets/initialAdminPassword
# 4e2869b4c9ca4782b018632ee1f2dd94

# Enter the password on the page
```

**4. Using only the JDK and Jenkins war file.**

```bash
# Download latest version of Jenkins War file
wget https://ftp-nyc.osuosl.org/pub/jenkins/war/latest/jenkins.war

# Run jenkins
java -jar jenkins.war

# Test:
curl localhost:8080

# To update Jenkins version
# https://medium.com/@jimkang/how-to-start-a-new-jenkins-container-and-update-jenkins-with-docker-cf628aa495e9
```

## Jenkins in action

Login to your Jenkins dashboard.

Default username: `admin`

Password is found in `~/.jenkins/secrets/initialAdminPassword`

Click on `New Item`

Give it the name `hello_world` and select Freestyle project, click ok.

Give it the description `Prints hello world to a new file in the home directory.`

In the `Build` section, add the build step `Execute Shell` with
the command `echo "Hello World" > ~/helloword.txt`

Click on `Save`.

Click `Back to Dashboard` in the top left.

Click on the button on the far right of where the `hello_world` project is displayed.
(It looks like a play button)

This will run the job.

Check the Circle on the far left column of the project to see if it succeeded or failed.

Click on the name of the project, this will bring you to the project page.

On the left of the page, you will see a Build History.

Click on the arrow next to the number of the most recent build
and select `Console Output`

Here you will see all output generated by that build.
This is useful if any errors have occurred.

This was just a simple example of Jenkins.

## Jenkins Dashboard

**Installing a plugin**:

Go to the Jenkins home page and select `Manage Jenkins`

Select `Manage Plugins`

Click on the `Available` tab and search for `email`

Select the `Email Extension` plugin.

Click `Install without restart` on the bottom.

Click on `Manage Jenkins` again and then select `Configure System`

Find the `Extended Email Notification` Section which was added by the plugin.

Now go back to `Manage Plugins` page.

Install the `GitHub` plugin.

Create a new project called `github_test` as Freestyle project.

Notice the new checkbox for `GitHub Project`
and the `Set build status to "Pending" on GitHub commit` option in
the Build section.
