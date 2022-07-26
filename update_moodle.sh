# File name: update_moodle.sh
############### Tham số cần thay đổi ở đây ###################
echo "FQDN: e.g: demo.company.vn"   # Đổi địa chỉ web thứ nhất (Website Master for Resource code - để tạo cùng 1 Source code duy nhất 
read -e folder_webmoodle

# switch to moodle source directory
cd /var/www/html/$folder_webmoodle;

# put moodle into maintenance mode
sudo -u www-data php /var/www/html/$folder_webmoodle/admin/cli/maintenance.php --enable;

# pull changes
git pull;

# run the moodle upgrade script to which you will have to answer: y
sudo -u www-data php /var/www/html/$folder_webmoodle/admin/cli/upgrade.php;

# Put moodle into regular mode again
sudo -u www-data php /var/www/html/$folder_webmoodle/admin/cli/maintenance.php --disable;

# run the cron script to clean up
sudo -u www-data php /var/www/html/$folder_webmoodle/admin/cli/cron.php;

# and switch back to your original directory
cd -;
