# MicrosoftSQLServerBackupToS3
Shell script to backup SQL Server to Amazon S3

Before run this script, install and configure:

-> sqlcmd

-> s3cmd



You can create a cron job to execute this script automatically, example:

*/30 * * * * /root/bin/db_backup.sh
