#!/bin/sh
#
# used to run on a docker image - see yafraorg docker.com 
#
export BASENODE=/work/repos
export PHPNODE=$BASENODE/yafra-php
export SYSADM=$BASENODE/yafra/org.yafra.sysadm
export WORKNODE=/work/yafra-runtime
export CI=true

echo "Install nodejs dependencies and prepare html front end pages"
cd $PHPNODE
git pull
npm -q install
bower --quite --allow-root install
cp -r backend /var/www/html
cp -r rest /var/www/html
cp -r bower_components /var/www/html
cp composer.json /var/www/html
cp index.php /var/www/html
cp main.css /var/www/html

echo "Install php dependencies and set ports"
cd /var/www/html
sed -i "/dbdsn/s/localhost/$DB_PORT_3306_TCP_ADDR/" backend/DbConnect.php
composer.phar install --no-dev

echo "if you want the apache rewrite htaccess enable: AllowOverride All"
# <Directory "/var/www">
#   AllowOverride All
# </Directory>
#sed  '/\[option\]/a Hello World' input

echo "start apache web server"
cd
a2enmod rewrite
apache2ctl start

echo "access it through http://server/rest/index.php/persons "
