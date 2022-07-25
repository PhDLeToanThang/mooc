# File name: install_moodle.sh
# 
cd ~
clear
sudo apt-get -y update
sudo apt-get -y upgrade
sudo apt-get install tasksel
sudo tasksel
sudo reboot
sudo apt-get install gparted
sudo apt-get install net-tools

#Install Web Control VM Ubuntu 20.04:
cd ~
sudo -s
. /etc/os-release
sudo apt-get install -t ${VERSION_CODENAME}-backports cockpit

#Install Nginx:
# Moodle works extremely well with Nginx as it offers a simple setup and serves static files blazingly fast. 
# Even though moodle is a huge PHP application it has advanced caching features. So Nginx is our choice:
sudo apt-get install nginx

#Install PHP and its dependencies:
sudo apt-get install php-fpm php-curl php-gd php-xmlrpc php-intl php-xml php-zip php-mbstring php-soap php-pgsql

#Install MariaDB vs MySQL:
#Postgres is a very reliable database. Technically MariaDB or MySQL should do to but we're focusing on speed:
#sudo apt-get install postgresql postgresql-contrib
sudo apt-get install postgresql postgresql-contrib

$phpmyadmin-fqdn = "phpmyadmin.cloud.edu.vn"

#Download and Install phpMyAdmin
sudo apt install phpmyadmin
sudo mysql -u root

#Then check the privileges.
show grants for phpmyadmin@localhost;
exit;

#Create Nginx Server Block
sudo nano /etc/nginx/conf.d/phpmyadmin.conf
server {
  listen 80;
  listen [::]:80;
  server_name $phpmyadmin-fqdn;
  root /usr/share/phpmyadmin/;
  index index.php index.html index.htm index.nginx-debian.html;

  access_log /var/log/nginx/phpmyadmin_access.log;
  error_log /var/log/nginx/phpmyadmin_error.log;

  location / {
    try_files $uri $uri/ /index.php;
  }

  location ~ ^/(doc|sql|setup)/ {
    deny all;
  }

  location ~ \.php$ {
    fastcgi_pass unix:/run/php/php7.2-fpm.sock;
    fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
    include fastcgi_params;
    include snippets/fastcgi-php.conf;
  }

  location ~ /\.ht {
    deny all;
  }
}

#Your phpMyAdmin files are in /usr/share/phpmyadmin/ directory. Save and close the file. Then test Nginx configurations.
sudo nginx -t
sudo systemctl reload nginx

#Log into MariaDB server from the command line.
sudo mariadb -u root
#Create an admin user with password authentication.
create user admin@localhost identified by 'your-chosen-password';
#Grant all privileges on all databases.
grant all privileges on *.* to admin@localhost with grant option;
#Flush privileges and exit;
flush privileges;
exit;

#Using a Different Port
sudo nano /etc/nginx/conf.d/phpmyadmin.conf
#Find the following two lines:
#listen [::]:443 ssl ipv6only=on; # managed by Certbot
#listen 443 ssl; # managed by Certbot
#Change 443 to a different port, for example, 8443.
#listen [::]:8443 ssl ipv6only=on; # managed by Certbot
#listen 8443 ssl; # managed by Certbot
#You can also add http2 to them like below to enable HTTP/2 protocol.
#listen [::]:8443 ssl http2 ipv6only=on; # managed by Certbot
#listen 8443 ssl http2; # managed by Certbot
#Save and close the file. Then test Nginx configurations.

sudo nginx -t
#If the test is successful, reload Nginx for the changes to take effect.
sudo systemctl reload nginx
#Now you can access phpMyAdmin via:
#https://pma.example.com:8443

#switch to moodle source directory
cd /usr/share/nginx/html/moodle;
# put moodle into maintenance mode
sudo -u www-data php /usr/share/nginx/html/moodle/admin/cli/maintenance.php --enable;
# pull changes
git pull;
# run the moodle upgrade script to which you will have to answer: y
sudo -u www-data php /usr/share/nginx/html/moodle/admin/cli/upgrade.php;
# Put moodle into regular mode again
sudo -u www-data php /usr/share/nginx/html/moodle/admin/cli/maintenance.php --disable;
# run the cron script to clean up
sudo -u www-data php /usr/share/nginx/html/moodle/admin/cli/cron.php;
# and switch back to your original directory
cd -;
