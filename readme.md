# Drupal Vagrant LAMP
A VirtualBox VM configured by Vagrant with a LAMP stack and other tools for Drupal development. Based on [Simple Vagrant LAMP VM](https://github.com/mwalters/simple-vagrant-lamp).

## Quickstart
- install [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
- install [Vagrant](http://www.vagrantup.com/downloads.html)
- clone repository `git clone https://github.com/eggplantpasta/drupal-vagrant-lamp myproject`
- `cd myproject`
- `vagrant up`
- Access the [webserver here](http://192.168.56.102), which is serving pages from the directory `./www`.
- Access php generated [mail here](http://192.168.56.102:1080/)

## Features
- Simple configuration using a single shell script to install packages, drush and drupal core.
- VM Configuration
	- 1GB RAM
	- Ubuntu 12.04 LTS 32-bit
	- Apache with mod_rewrite
	- MySQL
	- PHP
	- Pear
	- XDebug
	- [MailCatcher](http://mailcatcher.me/)
	- MySQL database named `devdb` and a username of `devdb` having access to it with the password `devdb`
	- Drush 6
	- Drupal 7

## Setup
The `Vagrantfile` shares the local folder: `./www`.  This is the web root of the website you want hosted in the VM.  If this folder dosn't exist it will be created when `vagrant up` is run. I recommend symlinking the folder from your current project to the vagrant folder and then you can just change the symlink to move between projects - e.g. `ln -fs ~/Sites/dev ./www`. You can do this either before or after `vagrant up`.

Edit your local hosts file to point a domain to 192.168.56.102 then use that domain in your browser to hit the site your VM is serving.

When you first boot the VM or recreate it, you might see some warning messages. These are usually harmless and are due to upgraded packages behaving slightly differently. 

## What is the bootstrap.sh script doing?
- Sets the MySQL root password to `root`
- Updates package lists
- Installs necessary packages
- Deletes the `test` database in MySQL
- Creates the `devdb` MySQL database and user
- Sets ServerName for Apache to keep it from complaining
- Enables mod_rewrite
- Allows use of .htaccess files
- Install MailCatcher
- Installs XDebug
- Sets PHP configuration values:
	- Send mail via MailCatcher
	- Turns on `display_errors`
	- Turns on `error_reporting` and sets to development values (display everything)
	- Turns on `html_errors`
	- Tells PHP about XDebug
- Installs Composer and uses that to install Drush 
- Starts MailCatcher
- Restarts Apache

## MailCatcher
- Load [http://192.168.56.102:1080/](http://192.168.56.102:1080/) in your browser to view the [MailCatcher](http://mailcatcher.me/) interface. This catches email being sent and let's you view it via a web interface rather than actually sending through the internet; which is probably not what you want to do during development.

