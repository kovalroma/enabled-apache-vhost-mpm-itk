# enabled-apache-vhost-mpm-itk
Bash Script to allow create apache virtual hosts on Ubuntu with mpm-itk module on a quick way.

## Usage
Basic command line syntax:

    $ sudo sh /path/to/add_vhost.sh [domain]

For example:
   
    $ sudo sh /path/to/add_vhost.sh ukr.net

## What does script do?

 - Add user **www-domaincom** and group **www-domaincom** to Linux for
   mpm-itk apache module
 - Create folder at **/var/www/domain.com/public_html/**
 - Add config to Apache virtual host
   **/etc/apache2/sites-available/domain.com.conf** folder and enable it
 - Set ownership and persmission to the folder and files
 - Add user to site group

 

