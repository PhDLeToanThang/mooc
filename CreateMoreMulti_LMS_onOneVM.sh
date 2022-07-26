cd ~

FQDN="digital.school.vn"    
FQDN1="lms.school.vn"   
FQDN2="demo.school.vn"   
FQDN3="elearning.school.vn"   
dbname="lmsdata"    
dbuser="lmsuser"    
dbpass="P@$$w0rd-1.22"
phpmyadmin="phpmysqladmin"    
FOLDERDATA="lmsdata"   
dbtype="mariadb"
dbhost="localhost"         
GitMoodleversion="MOODLE_400_STABLE"

############### Các bước thông thường để cài đặt đã được bỏ qua #########
#Step 1. Install NGINX

#Step 2. Install MariaDB/MySQL

#Step 3. Install PHP-FPM & Related modules

#Step 4. Create Moodle Database
#!/bin/bash
mysql -uroot -prootpassword -e "CREATE DATABASE $dbname CHARACTER SET utf8 COLLATE utf8_unicode_ci";
mysql -uroot -prootpassword -e "CREATE USER $dbuser@'dbhost' IDENTIFIED BY '$dbpass'";
mysql -uroot -prootpassword -e "GRANT ALL PRIVILEGES ON $dbname.* TO '$dbuser'@'dbhost'";
mysql -uroot -prootpassword -e "flush privileges";
mysql -uroot -prootpassword -e "SHOW DATABASES";

#Step 5. Next, edit the MariaDB default configuration file and define the innodb_file_format:

#Step 6. Download & Install Moodle
#We will be using Git to install/update the Moodle Core Application 
sudo apt install git

cd /opt
#Run the following command to download Moodle package.
#Download the Moodle Code and Index 

sudo git clone git://git.moodle.org/moodle.git

#Change directory into the downloaded Moodle folder 
cd moodle
git fetch

#Finally, Check out the Moodle version specified 
sudo git checkout $GitMoodleversion

#Run the following command to extract package to NGINX website root folder.
sudo cp -R /opt/moodle /var/www/html/$FQDN
sudo mkdir /var/www/html/$FOLDERDATA

#Change the folder permissions.
sudo chown -R www-data:www-data /var/www/html/$FQDN/ 
sudo chmod -R 755 /var/www/html/$FQDN/ 
sudo chown www-data /var/www/html/$FOLDERDATA

#Once the download is completed, edit the Mooc.cloud.edu.vn config.php and define the database type: 
cp /var/www/html/$FQDN/config-dist.php /var/www/html/$FQDN/config.php
#set database details with perl find and replace
sed -e "s/$CFG->dbtype *;/$dbtype/" /var/www/html/$FQDN/config.php
sed -e "s/$CFG->dbhost *;/$dbhost/" /var/www/html/$FQDN/config.php
sed -e "s/$CFG->dbname *;/$dbname/" /var/www/html/$FQDN/config.php
sed -e "s/$CFG->dbuser *;/$dbuser/" /var/www/html/$FQDN/config.php
sed -e "s/$CFG->dbpass *;/$dbpass/" /var/www/html/$FQDN/config.php
sed -e "s/$CFG->wwwroot *;/http://$FQDN/" /var/www/html/$FQDN/config.php
sed -e "s/$CFG->dataroot *;/var/www/html/$FOLDERDATA/" /var/www/html/$FQDN/config.php


#Step 7. Configure NGINX
#Next, you will need to create an Nginx virtual host configuration file to host Moodle:
# Configure for FQDN:
echo 'server {'  >> /etc/nginx/conf.d/$FQDN.conf
echo '    listen 80;' >> /etc/nginx/conf.d/$FQDN.conf
echo '    root '/var/www/html/${FQDN}';'>> /etc/nginx/conf.d/$FQDN.conf
echo '    index  index.php index.html index.htm;'>> /etc/nginx/conf.d/$FQDN.conf
echo '    server_name '${FQDN}';'>> /etc/nginx/conf.d/$FQDN.conf
echo '    client_max_body_size 512M;'>> /etc/nginx/conf.d/$FQDN.conf
echo '    autoindex off;'>> /etc/nginx/conf.d/$FQDN.conf
echo '    location / {'>> /etc/nginx/conf.d/$FQDN.conf
echo '        try_files $uri $uri/ =404;'>> /etc/nginx/conf.d/$FQDN.conf
echo '    }'>> /etc/nginx/conf.d/$FQDN.conf
echo '    location /dataroot/ {'>> /etc/nginx/conf.d/$FQDN.conf
echo '      internal;'>> /etc/nginx/conf.d/$FQDN.conf
echo '      alias '/var/www/html/$FOLDERDATA/';'>> /etc/nginx/conf.d/$FQDN.conf
echo '    }'>> /etc/nginx/conf.d/$FQDN.conf
echo '    location ~ [^/].php(/|$) {'>> /etc/nginx/conf.d/$FQDN.conf
echo '        include snippets/fastcgi-php.conf;'>> /etc/nginx/conf.d/$FQDN.conf
echo '        fastcgi_pass unix:/run/php/php8.0-fpm.sock;'>> /etc/nginx/conf.d/$FQDN.conf
echo '        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;'>> /etc/nginx/conf.d/$FQDN.conf
echo '        include fastcgi_params;'>> /etc/nginx/conf.d/$FQDN.conf
echo '    }'>> /etc/nginx/conf.d/$FQDN.conf
echo '	location ~ ^/(doc|sql|setup)/{'>> /etc/nginx/conf.d/$FQDN.conf
echo '		deny all;'>> /etc/nginx/conf.d/$FQDN.conf
echo '	}'>> /etc/nginx/conf.d/$FQDN.conf
echo '}'>> /etc/nginx/conf.d/$FQDN.conf


# Configure for FQDN1:
echo 'server {'  >> /etc/nginx/conf.d/$FQDN1.conf
echo '    listen 80;' >> /etc/nginx/conf.d/$FQDN1.conf
echo '    root '/var/www/html/${FQDN}';'>> /etc/nginx/conf.d/$FQDN1.conf
echo '    index  index.php index.html index.htm;'>> /etc/nginx/conf.d/$FQDN1.conf
echo '    server_name '${FQDN1}';'>> /etc/nginx/conf.d/$FQDN1.conf
echo '    client_max_body_size 512M;'>> /etc/nginx/conf.d/$FQDN1.conf
echo '    autoindex off;'>> /etc/nginx/conf.d/$FQDN1.conf
echo '    location / {'>> /etc/nginx/conf.d/$FQDN1.conf
echo '        try_files $uri $uri/ =404;'>> /etc/nginx/conf.d/$FQDN1.conf
echo '    }'>> /etc/nginx/conf.d/$FQDN1.conf
echo '    location /dataroot/ {'>> /etc/nginx/conf.d/$FQDN1.conf
echo '      internal;'>> /etc/nginx/conf.d/$FQDN1.conf
echo '      alias '/var/www/html/$FOLDERDATA/';'>> /etc/nginx/conf.d/$FQDN1.conf
echo '    }'>> /etc/nginx/conf.d/$FQDN1.conf
echo '    location ~ [^/].php(/|$) {'>> /etc/nginx/conf.d/$FQDN1.conf
echo '        include snippets/fastcgi-php.conf;'>> /etc/nginx/conf.d/$FQDN1.conf
echo '        fastcgi_pass unix:/run/php/php8.0-fpm.sock;'>> /etc/nginx/conf.d/$FQDN1.conf
echo '        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;'>> /etc/nginx/conf.d/$FQDN1.conf
echo '        include fastcgi_params;'>> /etc/nginx/conf.d/$FQDN1.conf
echo '    }'>> /etc/nginx/conf.d/$FQDN1.conf
echo '	location ~ ^/(doc|sql|setup)/{'>> /etc/nginx/conf.d/$FQDN1.conf
echo '		deny all;'>> /etc/nginx/conf.d/$FQDN1.conf
echo '	}'>> /etc/nginx/conf.d/$FQDN1.conf
echo '}'>> /etc/nginx/conf.d/$FQDN1.conf


# Configure for FQDN2:
echo 'server {'  >> /etc/nginx/conf.d/$FQDN2.conf
echo '    listen 80;' >> /etc/nginx/conf.d/$FQDN2.conf
echo '    root '/var/www/html/${FQDN}';'>> /etc/nginx/conf.d/$FQDN2.conf
echo '    index  index.php index.html index.htm;'>> /etc/nginx/conf.d/$FQDN2.conf
echo '    server_name '${FQDN2}';'>> /etc/nginx/conf.d/$FQDN2.conf
echo '    client_max_body_size 512M;'>> /etc/nginx/conf.d/$FQDN2.conf
echo '    autoindex off;'>> /etc/nginx/conf.d/$FQDN2.conf
echo '    location / {'>> /etc/nginx/conf.d/$FQDN2.conf
echo '        try_files $uri $uri/ =404;'>> /etc/nginx/conf.d/$FQDN2.conf
echo '    }'>> /etc/nginx/conf.d/$FQDN2.conf
echo '    location /dataroot/ {'>> /etc/nginx/conf.d/$FQDN2.conf
echo '      internal;'>> /etc/nginx/conf.d/$FQDN2.conf
echo '      alias '/var/www/html/$FOLDERDATA/';'>> /etc/nginx/conf.d/$FQDN2.conf
echo '    }'>> /etc/nginx/conf.d/$FQDN2.conf
echo '    location ~ [^/].php(/|$) {'>> /etc/nginx/conf.d/$FQDN2.conf
echo '        include snippets/fastcgi-php.conf;'>> /etc/nginx/conf.d/$FQDN2.conf
echo '        fastcgi_pass unix:/run/php/php8.0-fpm.sock;'>> /etc/nginx/conf.d/$FQDN2.conf
echo '        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;'>> /etc/nginx/conf.d/$FQDN2.conf
echo '        include fastcgi_params;'>> /etc/nginx/conf.d/$FQDN2.conf
echo '    }'>> /etc/nginx/conf.d/$FQDN2.conf
echo '	location ~ ^/(doc|sql|setup)/{'>> /etc/nginx/conf.d/$FQDN2.conf
echo '		deny all;'>> /etc/nginx/conf.d/$FQDN2.conf
echo '	}'>> /etc/nginx/conf.d/$FQDN2.conf
echo '}'>> /etc/nginx/conf.d/$FQDN2.conf


# Configure for FQDN3:
echo 'server {'  >> /etc/nginx/conf.d/$FQDN3.conf
echo '    listen 80;' >> /etc/nginx/conf.d/$FQDN3.conf
echo '    root '/var/www/html/${FQDN}';'>> /etc/nginx/conf.d/$FQDN3.conf
echo '    index  index.php index.html index.htm;'>> /etc/nginx/conf.d/$FQDN3.conf
echo '    server_name '${FQDN3}';'>> /etc/nginx/conf.d/$FQDN3.conf
echo '    client_max_body_size 512M;'>> /etc/nginx/conf.d/$FQDN3.conf
echo '    autoindex off;'>> /etc/nginx/conf.d/$FQDN3.conf
echo '    location / {'>> /etc/nginx/conf.d/$FQDN3.conf
echo '        try_files $uri $uri/ =404;'>> /etc/nginx/conf.d/$FQDN3.conf
echo '    }'>> /etc/nginx/conf.d/$FQDN3.conf
echo '    location /dataroot/ {'>> /etc/nginx/conf.d/$FQDN3.conf
echo '      internal;'>> /etc/nginx/conf.d/$FQDN3.conf
echo '      alias '/var/www/html/$FOLDERDATA/';'>> /etc/nginx/conf.d/$FQDN3.conf
echo '    }'>> /etc/nginx/conf.d/$FQDN3.conf
echo '    location ~ [^/].php(/|$) {'>> /etc/nginx/conf.d/$FQDN3.conf
echo '        include snippets/fastcgi-php.conf;'>> /etc/nginx/conf.d/$FQDN3.conf
echo '        fastcgi_pass unix:/run/php/php8.0-fpm.sock;'>> /etc/nginx/conf.d/$FQDN3.conf
echo '        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;'>> /etc/nginx/conf.d/$FQDN3.conf
echo '        include fastcgi_params;'>> /etc/nginx/conf.d/$FQDN3.conf
echo '    }'>> /etc/nginx/conf.d/$FQDN3.conf
echo '	location ~ ^/(doc|sql|setup)/{'>> /etc/nginx/conf.d/$FQDN3.conf
echo '		deny all;'>> /etc/nginx/conf.d/$FQDN3.conf
echo '	}'>> /etc/nginx/conf.d/$FQDN3.conf
echo '}'>> /etc/nginx/conf.d/$FQDN3.conf


#Save and close the file then verify the Nginx for any syntax error with the following command: 
nginx -t

#8. Setup and Configure PhpMyAdmin

#9. Cách gỡ apache:

#10. Nâng cấp PhpmyAdmin lên version 5.2:
sudo ln -s /usr/share/phpmyadmin /var/www/html/$FQDN/$phpmyadmin

#11. Install Certbot
sudo apt install certbot python3-certbot-nginx
sudo certbot --nginx -d $FQDN  -d $FQDN1 -d $FQDN2 -d $FQDN3

# You should test your configuration at:
# https://www.ssllabs.com/ssltest/analyze.html?d=$FQDN
#/etc/letsencrypt/live/$FQDN/fullchain.pem
#   Your key file has been saved at:
#   /etc/letsencrypt/live/$FQDN/privkey.pem
#   Your cert will expire on 2022-10-20. To obtain a new or tweaked
#   version of this certificate in the future, simply run certbot again
#   with the "certonly" option. To non-interactively renew *all* of
#   your certificates, run "certbot renew"
