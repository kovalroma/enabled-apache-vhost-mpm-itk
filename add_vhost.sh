#!/bin/bash

domainUrl=$1

### Are you root ?
if [ "$(whoami)" != 'root' ]; then
	echo $"You have no permission to run $0 as non-root user. Use sudo"
		exit 1;
fi

if [ -z "$domainUrl" ]; then 
	echo 'Add URL site address without www subdomain (example ukr.net) '
	read domainUrl; 
fi	

echo 'Are you sure to continue with' $domainUrl '? [Y,n]'
read continue;

if [ $continue != 'y' ]; then 
		echo 'Your answer is no. Good bye!';
		exit 0
   		
fi   

echo "Ok let's go to the next step..." 

### Convert domain adress without '.'
domainWithoutDot=${domainUrl//[-._]/}

### Add group for vhost 
echo 'Add group' 'www-'$domainWithoutDot 
addgroup 'www-'$domainWithoutDot 
echo 'group' 'www-'$domainWithoutDot 'was succesfully added'

### Add vhost directory
echo 'Creating directory for vhost' 
mkdir -p /var/www/$domainUrl/public_html 
echo 'Directory was succesfully created' 

### Add user for vhost
echo 'Add user for vhost' 
useradd -s /bin/false -d /var/www/$domainUrl/public_html -m -g 'www-'$domainWithoutDot 'www-'$domainWithoutDot
echo 'User was succesfully created' 

echo 'Creating vhost file' 

### Add vhost config file
echo "
     <VirtualHost *:80>

        ServerName $domainUrl
        ServerAlias www.$domainUrl
        ServerAdmin root@$domainUrl
        DocumentRoot /var/www/$domainUrl/public_html
		<IfModule mpm_itk_module>
    		AssignUserId www-$domainWithoutDot www-$domainWithoutDot
    	</IfModule>
        
        <Directory /var/www/$domainUrl/public_html/>
        Options FollowSymLinks
        AllowOverride All
        </Directory>


        ErrorLog /var/log/apache2/$domainUrl-error.log
        CustomLog /var/log/apache2/$domainUrl-access.log combined


</VirtualHost>" > /etc/apache2/sites-available/$domainUrl.conf

### Enable vhost settings
a2ensite $domainUrl.conf
service apache2 reload

echo 'Set directory and files permission'

### Add owner and permission for read,write,execute for user and group only
chown -R www-$domainWithoutDot:www-$domainWithoutDot /var/www/$domainUrl/public_html
find /var/www/$domainUrl/public_html -type d -exec chmod 770 {} + 
find /var/www/$domainUrl/public_html -type f -exec chmod 660 {} +

### Add user to vhost group
echo 'Write your linux username';
read linuxUsername;
echo 'Add '$linuxUsername 'to the www-'$domainWithoutDot' group ';
usermod -a -G www-$domainWithoutDot $linuxUsername;

exit 0;