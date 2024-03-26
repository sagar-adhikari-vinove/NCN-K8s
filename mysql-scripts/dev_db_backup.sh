#!/usr/bin/env bash
SSHPASS=$(grep -E '^SSHPASS=' /etc/environment | cut -d= -f2)

#echo $SSHPASS
now="$(date +'%d_%m_%Y')"
old="$(date +%d_%m_%Y --date='7 day ago')"
old_filename="in1_ot_pax8_dev_$old".gz
filename="in1_ot_pax8_dev_$now".gz
backupfolder="/home/gitlab-runner/mysql-scripts"
fullpathbackupfile="$backupfolder/$filename"
logfile="$backupfolder/"backup_log_"$(date +'%Y_%m')".txt
echo "mysqldump started at $(date +'%d-%m-%Y %H:%M:%S')" >> "$logfile"
mysqldump --user=ottestuser --password=$DB_PASS -h 104.37.223.143 --default-character-set=utf8 ot_pax8_dev --routines --triggers --events | gzip > "$fullpathbackupfile"
echo "mysqldump finished at $(date +'%d-%m-%Y %H:%M:%S')" >> "$logfile"
chown gitlab-runner "$fullpathbackupfile"
chown gitlab-runner "$logfile"
echo "file permission changed" >> "$logfile"
echo "old files deleted" >> "$logfile"
echo "operation finished at $(date +'%d-%m-%Y %H:%M:%S')" >> "$logfile"
echo "*****************" >> "$logfile"

sshpass -e sftp -oBatchMode=no -b - ocpuser@204.13.180.17 << !
   cd in1-dev
   put "$fullpathbackupfile"
  # rm "$old_filename"
   bye
!
rm -rf "$fullpathbackupfile"

exit 0
