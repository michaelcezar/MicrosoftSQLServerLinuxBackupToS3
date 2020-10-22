#Scrip to backup mssql and send do aws s3 - Michael Cezar - 2020-10-20 19:20

#Set variables
TIMESTAMP=$(date --iso-8601=seconds)
BACKUP_DIR="var/opt/mssql/backup/$TIMESTAMP"
DB_USER="db_user"
DB_PASS="db_pass"

#Create new directory
sudo mkdir -p "$BACKUP_DIR"

#Permission to mssql on new directory
sudo chown -R mssql:mssql $BACKUP_DIR

#Folder Permission
sudo chmod -R 777 $BACKUP_DIR 

#Backup Databse
sqlcmd -S 127.0.0.1 -Q "BACKUP DATABASE [YOUR_DB] TO DISK = N'$BACKUP_DIR/your_db.bak' WITH NOFORMAT, NOINIT, SKIP, NOREWIND, STATS=10" -U $DB_USER -P $DB_PASS

#Put Backup Database S3
sudo s3cmd put "$BACKUP_DIR/your_db.bak" "s3://your-bucket/database/backup/$TIMESTAMP/your_db.bak"

#Backup Database Log
sqlcmd -S 127.0.0.1 -Q "BACKUP LOG [YOUR_DB] TO DISK = N'$BACKUP_DIR/your_db_log.bak' WITH NOFORMAT, NOINIT, SKIP, NOREWIND, STATS=10" -U $DB_USER -P $DB_PASS

#Put Backup Database Log S3
sudo s3cmd put "$BACKUP_DIR/your_db_log.bak" "s3://your-bucket/database/backup/$TIMESTAMP/your_db_log.bak"

#Remove local Backup Directory
sudo rm -rf "$BACKUP_DIR"
