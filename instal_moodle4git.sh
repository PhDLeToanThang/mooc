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
cat > /etc/php/8.0/fpm/php.ini <<END
#Add/Update the values as shown. You may change it as per your requirement.
file_uploads = On 
allow_url_fopen = On 
memory_limit = 512M 
upload_max_filesize = 4096M 
max_execution_time = 360 
cgi.fix_pathinfo = 0 
date.timezone = asia/ho_chi_minh
END
 
systemctl restart php8.0-fpm

#Step 4. Create Moodle Database
#Log into MySQL and create database for Moodle.
#sudo mysql -u root -p
#create database moocdatabase;
#create user moocuser@localhost identified by 'P@$$w0rd';
#grant all privileges on moocdatabase.* to moocuser@localhost;
#Flush privileges to apply changes.
#flush privileges;
#exit;

#sudo mysql -u root -p
#SHOW DATABASES;

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
sudo git branch -a
#Tell git which branch to track or use 
sudo git branch --track MOODLE_400_STABLE origin/MOODLE_400_STABLE

#if get error
#git fetch
#Finally, Check out the Moodle version specified 
sudo git checkout MOODLE_400_STABLE
#Run the following command to extract package to NGINX website root folder.
sudo cp -R /opt/moodle /var/www/html/mooc.cloud.edu.vn
sudo mkdir /var/www/html/moocdata
#Change the folder permissions.
sudo chown -R www-data:www-data /var/www/html/mooc.cloud.edu.vn/ 
sudo chmod -R 755 /var/www/html/mooc.cloud.edu.vn/ 
sudo chown www-data /var/www/html/moocdata

#Once the download is completed, edit the Mooc.cloud.edu.vn config.php and define the database type: 
cp /var/www/html/mooc.cloud.edu.vn/config-dist.php /var/www/html/mooc.cloud.edu.vn/config.php
#nano /var/www/html/mooc.cloud.edu.vn/config.php
#And, replaced it with the following line: 

echo '"$CFG->dbtype    = 'mariadb';"' >> /var/www/html/mooc.cloud.edu.vn/config.php
echo '"$CFG->dblibrary = 'native';"' >> /var/www/html/mooc.cloud.edu.vn/config.php
echo '"$CFG->dbhost = 'localhost';"' >> /var/www/html/mooc.cloud.edu.vn/config.php
echo '"$CFG->dbname = 'moocdatabase';"' >> /var/www/html/mooc.cloud.edu.vn/config.php
echo '"$CFG->dbuser = 'moocuser';"' >> /var/www/html/mooc.cloud.edu.vn/config.php
echo '"$CFG->dbpass = 'P@$$w0rd';"' >> /var/www/html/mooc.cloud.edu.vn/config.php
echo '"$CFG->wwwroot ='http://mooc.cloud.edu.vn';"' >> /var/www/html/mooc.cloud.edu.vn/config.php
echo '"$CFG->dataroot ='/var/www/html/moocdata';"' >> /var/www/html/mooc.cloud.edu.vn/config.php

#Step 7. Configure NGINX

