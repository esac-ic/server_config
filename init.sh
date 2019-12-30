#run this script first time after pulling to set the right userrights
chown -R deploy:deploy .
chown -R www-data:www-data storage/
chown deploy:deploy storage/app/public/versions.txt
chmod  u+x start.sh
chmod  u+x update.sh
