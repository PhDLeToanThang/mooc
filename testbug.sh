# Debug Add-multi company
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


#Step 4. Create Moodle Database
#Log into MySQL and create database for Moodle.
#!/bin/bash
mysql -uroot -prootpassword -e "CREATE DATABASE $dbname CHARACTER SET utf8 COLLATE utf8_unicode_ci";
mysql -uroot -prootpassword -e "CREATE USER '$dbuser'@'$dbhost' IDENTIFIED BY '$dbpass'";
mysql -uroot -prootpassword -e "GRANT ALL PRIVILEGES ON $dbname.* TO '$dbuser'@'$dbhost'";
mysql -uroot -prootpassword -e "FLUSH PRIVILEGES";
mysql -uroot -prootpassword -e "SHOW DATABASES";

# Set tạo file config-sample.php 
echo "<?php"  >> /var/www/html/$FQDN/config1.php
echo "unset($CFG);" >> /var/www/html/$FQDN/config1.php
echo "global $CFG;" >> /var/www/html/$FQDN/config1.php
echo "$CFG = new stdClass();" >> /var/www/html/$FQDN/config1.php
echo "$CFG->dbtype    = '$dbtype';" >> /var/www/html/$FQDN/config1.php
echo "$CFG->dblibrary = 'native';" >> /var/www/html/$FQDN/config1.php
echo "$CFG->dbhost    = '$dbhost';" >> /var/www/html/$FQDN/config1.php
echo "$CFG->dbname    = '$dbname';" >> /var/www/html/$FQDN/config1.php
echo "$CFG->dbuser    = '$dbuser';" >> /var/www/html/$FQDN/config1.php
echo "$CFG->dbpass    = '$dbpass';" >> /var/www/html/$FQDN/config1.php
echo "$CFG->prefix    = 'mdl_';" >> /var/www/html/$FQDN/config1.php
echo "$CFG->dboptions = array(" >> /var/www/html/$FQDN/config1.php
echo "'dbpersist' => false,"  >> /var/www/html/$FQDN/config1.php
echo "'dbsocket'  => false,"  >> /var/www/html/$FQDN/config1.php
echo "'dbport' => '',"  >> /var/www/html/$FQDN/config1.php
echo "'dbhandlesoptions' => false,"  >> /var/www/html/$FQDN/config1.php
echo "'dbcollation' => 'utf8mb4_unicode_ci'," >> /var/www/html/$FQDN/config1.php
echo ");" >> /var/www/html/$FQDN/config1.php
echo "$CFG->wwwroot   = 'https://$FQDN';" >> /var/www/html/$FQDN/config1.php
echo "$CFG->dataroot  = '/var/www/html/$FOLDERDATA';" >> /var/www/html/$FQDN/config1.php
echo "$CFG->directorypermissions = 02777;" >> /var/www/html/$FQDN/config1.php
echo "$CFG->admin = 'admin';" >> /var/www/html/$FQDN/config1.php
echo "require_once(__DIR__ . '/lib/setup.php');" >> /var/www/html/$FQDN/config1.php
