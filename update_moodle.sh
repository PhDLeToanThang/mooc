# File name: update_moodle.sh
# 
# switch to moodle source directory
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
