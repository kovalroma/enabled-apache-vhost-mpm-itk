#!/bin/bash

echo 'Add URL site address without www subdomain (example ukr.net) '
read domainUrl;

domainWithoutDot=${domainUrl//[-._]/}

chown -R www-$domainWithoutDot:www-$domainWithoutDot /var/www/$domainUrl/public_html
find /var/www/$domainUrl/public_html -type d -exec chmod 770 {} + 
find /var/www/$domainUrl/public_html -type f -exec chmod 660 {} +

exit 0