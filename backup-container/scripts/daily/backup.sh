dt=$(date '+%Y%m%d');

mysqldump -h $DB_HOST -u $DB_USERNAME -P $DB_PORT -p$DB_PASSWORD --databases $DB_DATABASE > $DB_DATABASE"_"${dt}.sql


#compressing the storage directory
#-z : Compress archive using gzip program in Linux or Unix
#-c : Create archive on Linux
#-v : Verbose i.e display progress while creating archive
#-f : Archive File name
tar -zcvf "storage_"$dt".gz" /storage

#copying files to the backup folder
cp "storage_"$dt".gz" /backups
cp $DB_DATABASE"_"${dt}.sql /backups