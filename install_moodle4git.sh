clear
cd ~
############### Tham số cần thay đổi ở đây ###################
echo "FQDN: e.g: demo.company.vn"   # Đổi địa chỉ web thứ nhất Website Master for Resource code - để tạo cùng 1 Source code duy nhất 
read -e FQDN
echo "dbname: e.g: demodata"   # Tên DBNane
read -e dbname
echo "dbuser: e.g: userdata"   # Tên User access DB lmsatcuser
read -e dbuser
echo "Database Password: e.g: P@$$w0rd-1.22"
read -s dbpass
echo "phpmyadmin folder name: e.g: phpmyadmin"   # Đổi tên thư mục phpmyadmin khi add link symbol vào Website 
read -e phpmyadmin
echo "Moodle Folder Data: e.g: moodledata"   # Tên Thư mục chưa Data vs Cache
read -e FOLDERDATA
echo "dbtype name: e.g: mariadb"   # Tên kiểu Database
read -e dbtype
echo "dbhost name: e.g: localhost"   # Tên Db host connector
read -e dbhost
        
GitMoodleversion="MOODLE_400_STABLE"

echo "run install? (y/n)"
read -e run
if [ "$run" == n ] ; then
  exit
else

#Step 1. Install NGINX
sudo apt-get update
sudo apt-get install nginx
sudo systemctl stop nginx.service 
sudo systemctl start nginx.service 
sudo systemctl enable nginx.service

#Step 2. Install MariaDB/MySQL
#Run the following commands to install MariaDB database for Moode. You may also use MySQL instead.
sudo apt-get install mariadb-server mariadb-client

#Like NGINX, we will run the following commands to enable MariaDB to autostart during reboot, and also start now.
sudo systemctl stop mysql.service 
sudo systemctl start mysql.service 
sudo systemctl enable mysql.service

#Run the following command to secure MariaDB installation.
sudo mysql_secure_installation

#You will see the following prompts asking to allow/disallow different type of logins. Enter Y as shown.
# Enter current password for root (enter for none): Just press the Enter
# Set root password? [Y/n]: Y
# New password: Enter password
# Re-enter new password: Repeat password
# Remove anonymous users? [Y/n]: Y
# Disallow root login remotely? [Y/n]: N
# Remove test database and access to it? [Y/n]:  Y
# Reload privilege tables now? [Y/n]:  Y
# After you enter response for these questions, your MariaDB installation will be secured.

#Step 3. Install PHP-FPM & Related modules
sudo apt-get install software-properties-common
sudo add-apt-repository ppa:ondrej/php
sudo apt update
sudo apt install php8.0-fpm php8.0-common php8.0-mbstring php8.0-xmlrpc php8.0-soap php8.0-gd php8.0-xml php8.0-intl php8.0-mysql php8.0-cli php8.0-mcrypt php8.0-ldap php8.0-zip php8.0-curl 

#Open PHP-FPM config file.

#sudo nano /etc/php/8.0/fpm/php.ini
#Add/Update the values as shown. You may change it as per your requirement.
cat > /etc/php/8.0/fpm/php.ini <<END
file_uploads = On 
allow_url_fopen = On 
memory_limit = 1200M 
upload_max_filesize = 4096M
max_execution_time = 360 
cgi.fix_pathinfo = 0 
date.timezone = asia/ho_chi_minh
max_input_time = 60
max_input_nesting_level = 64
max_input_vars = 5000
post_max_size = 4096M
END
systemctl restart php8.0-fpm.service

#Step 4. Create Moodle Database
#Log into MySQL and create database for Moodle.
#!/bin/bash

mysql -uroot -prootpassword -e "CREATE DATABASE $dbname CHARACTER SET utf8 COLLATE utf8_unicode_ci";
mysql -uroot -prootpassword -e "CREATE USER $dbuser@$dbhost IDENTIFIED BY $dbpass";
mysql -uroot -prootpassword -e "GRANT ALL PRIVILEGES ON $dbname.* TO $dbuser@$dbhost";
mysql -uroot -prootpassword -e "FLUSH PRIVILEGES";
mysql -uroot -prootpassword -e "SHOW DATABASES";

#Step 5. Next, edit the MariaDB default configuration file and define the innodb_file_format:
#nano /etc/mysql/mariadb.conf.d/50-server.cnf
#Add the following lines inside the [mysqld] section: 
cat > /etc/mysql/mariadb.conf.d/50-server.cnf <<END
[mysqld]
innodb_file_format = Barracuda
innodb_file_per_table = 1
innodb_large_prefix = ON
END

#Save the file then restart the MariaDB service to apply the changes.
systemctl restart mariadb

#Step 6. Download & Install Moodle
#We will be using Git to install/update the Moodle Core Application 
sudo apt install git

cd /opt
#Run the following command to download Moodle package.
#Download the Moodle Code and Index 
sudo git clone git://git.moodle.org/moodle.git
#Change directory into the downloaded Moodle folder 
cd moodle
#Retrieve a list of each branch available 
#sudo git branch -a
#Tell git which branch to track or use 
#sudo git branch --track $GitMoodleversion origin/$GitMoodleversion

#if get error
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
#cp /var/www/html/$FQDN/config-dist.php /var/www/html/$FQDN/config.php
#set database details with perl find and replace
echo '<?php'  >> /var/www/html/$FQDN/config.php
echo 'unset($CFG);' >> /var/www/html/$FQDN/config.php
echo 'global $CFG;' >> /var/www/html/$FQDN/config.php
echo '$CFG = new stdClass();' >> /var/www/html/$FQDN/config.php
echo '$CFG->dbtype    = '$dbtype';' >> /var/www/html/$FQDN/config.php
echo '$CFG->dblibrary = 'native';' >> /var/www/html/$FQDN/config.php
echo '$CFG->dbhost    = '$dbhost';' >> /var/www/html/$FQDN/config.php
echo '$CFG->dbname    = '$dbname';' >> /var/www/html/$FQDN/config.php
echo '$CFG->dbuser    = '$dbuser';' >> /var/www/html/$FQDN/config.php
echo '$CFG->dbpass    = '$dbpass';' >> /var/www/html/$FQDN/config.php
echo '$CFG->prefix    = 'mdl_';' >> /var/www/html/$FQDN/config.php
echo '$CFG->dboptions = array(' >> /var/www/html/$FQDN/config.php
echo 'dbpersist' => false,       ' >> /var/www/html/$FQDN/config.php
echo 'dbsocket'  => false,       ' >> /var/www/html/$FQDN/config.php
echo 'dbport'    => '',          ' >> /var/www/html/$FQDN/config.php
echo 'dbhandlesoptions' => false, ' >> /var/www/html/$FQDN/config.php
echo 'dbcollation' => 'utf8mb4_unicode_ci',);' >> /var/www/html/$FQDN/config.php
echo '$CFG->wwwroot   = 'https://$FQDN';' >> /var/www/html/$FQDN/config.php
echo '$CFG->dataroot  = '/var/www/html/$FOLDERDATA';' >> /var/www/html/$FQDN/config.php
echo '$CFG->directorypermissions = 02777;' >> /var/www/html/$FQDN/config.php
echo '$CFG->admin = 'admin';' >> /var/www/html/$FQDN/config.php
echo 'require_once(__DIR__ . '/lib/setup.php');' >> /var/www/html/$FQDN/config.php

#Step 7. Configure NGINX

#Next, you will need to create an Nginx virtual host configuration file to host Moodle:
#$ nano /etc/nginx/conf.d/$FQDN.conf
echo 'server {'  >> /etc/nginx/conf.d/$FQDN.conf
echo '    listen 80;' >> /etc/nginx/conf.d/$FQDN.conf
echo '    root /var/www/html/'$FQDN';'>> /etc/nginx/conf.d/$FQDN.conf
echo '    index  index.php index.html index.htm;'>> /etc/nginx/conf.d/$FQDN.conf
echo '    server_name '$FQDN';'>> /etc/nginx/conf.d/$FQDN.conf
echo '    client_max_body_size 512M;'>> /etc/nginx/conf.d/$FQDN.conf
echo '    autoindex off;'>> /etc/nginx/conf.d/$FQDN.conf
echo '    location / {'>> /etc/nginx/conf.d/$FQDN.conf
echo '        try_files $uri $uri/ =404;'>> /etc/nginx/conf.d/$FQDN.conf
echo '    }'>> /etc/nginx/conf.d/$FQDN.conf
echo '    location /dataroot/ {'>> /etc/nginx/conf.d/$FQDN.conf
echo '      internal;'>> /etc/nginx/conf.d/$FQDN.conf
echo '      alias /var/www/html/'$FOLDERDATA'/;'>> /etc/nginx/conf.d/$FQDN.conf
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

#Save and close the file then verify the Nginx for any syntax error with the following command: 
nginx -t

#8. Setup and Configure PhpMyAdmin
sudo apt update
sudo apt install phpmyadmin

#9. gỡ bỏ apache:
sudo service apache2 stop
sudo apt-get purge apache2 apache2-utils apache2.2-bin apache2-common
sudo apt-get purge apache2 apache2-utils apache2-bin apache2.2-common

sudo apt-get autoremove
whereis apache2
apache2: /etc/apache2
sudo rm -rf /etc/apache2

sudo ln -s /usr/share/phpmyadmin /var/www/html/$FQDN/$phpmyadmin
sudo chown -R root:root /var/lib/phpmyadmin
sudo nginx -t

#10. Nâng cấp PhpmyAdmin lên version 5.2:
sudo mv /usr/share/phpmyadmin/ /usr/share/phpmyadmin.bak
sudo mkdir /usr/share/phpmyadmin/
cd /usr/share/phpmyadmin/
sudo wget https://files.phpmyadmin.net/phpMyAdmin/5.2.0/phpMyAdmin-5.2.0-all-languages.tar.gz
sudo tar xzf phpMyAdmin-5.2.0-all-languages.tar.gz
#Once extracted, list folder.
ls
#You should see a new folder phpMyAdmin-5.2.0-all-languages
#We want to move the contents of this folder to /usr/share/phpmyadmin
sudo mv phpMyAdmin-5.2.0-all-languages/* /usr/share/phpmyadmin
ls /usr/share/phpmyadmin
mkdir /usr/share/phpMyAdmin/tmp   # tạo thư mục cache cho phpmyadmin 

sudo systemctl restart nginx
systemctl restart php8.0-fpm.service

#11. Install Certbot
sudo apt install certbot python3-certbot-nginx
sudo certbot --nginx -d $FQDN

# You should test your configuration at:
# https://www.ssllabs.com/ssltest/analyze.html?d=$FQDN
#/etc/letsencrypt/live/$FQDN/fullchain.pem
#   Your key file has been saved at:
#   /etc/letsencrypt/live/$FQDN/privkey.pem
#   Your cert will expire on yyyy-mm-dd. To obtain a new or tweaked
#   version of this certificate in the future, simply run certbot again
#   with the "certonly" option. To non-interactively renew *all* of
#   your certificates, run "certbot renew"
fi
