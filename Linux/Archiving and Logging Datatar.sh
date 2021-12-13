#Step 1: Create, Extract, Compress, and Manage tar Backup Archives
#Command to extract the TarDocs.tar archive to the current directory:
tar -xvvf TarDocs.tar

#Command to create the Javaless_Doc.tar archive from the TarDocs/ directory, while excluding the TarDocs/Documents/Java directory:
sudo tar -cvf Javaless_Doc.tar --exclude="TarDocs/Documents/Java" ./TarDocs

#Command to ensure Java/ is not in the new Javaless_Docs.tar archive:
tar -tvf Javaless_Doc.tar | grep Java

#Bonus
#Command to create an incremental archive called logs_backup_tar.gz with only changed files to snapshot.file for the /var/log directory:
sudo tar czvf logs_backup.tar.gz --listed-incremental=logs_backup.snar --level=0 /var/log

#Step 2: Create, Manage, and Automate Cron Jobs
#Cron job for backing up the /var/log/auth.log file:
#To backup auth.log you need to access crontab -e for nano editing and input the following command to meet the required backup timeframe.
0 6 * * */3 tar -czvf auth_backup.tgz /var/log/auth.log

#Step 3: Write Basic Bash Scripts
#Brace expansion command to create the four subdirectories:
mkdir -p backups/{freemem,diskuse,openlist,freedisk}

#Example system.sh script that has been edited:
#!/bin/bash
#Memory information displayed in a human readable format
free -h > ~/Projects/backups/freemem/free_mem.txt
#Disk Usage Displayed in a human readable format
du -ah -c > ~/Projects/backups/diskuse/disk_use.txt
#Will display all open files
lsof > ~/Projects/backups/openlist/open_list.txt
#Command for displaying free disk in human readable format
df -h > ~/Projects/backups/freedisk/free_disk.txt

#Command to make the system.sh script executable:
chmod +x system.sh

#Optional
#Commands to test the script and confirm its execution:
cd
./system.sh
cat ~/Projects/backups/freemem/free_mem.txt
cat ~/Projects/backups/diskuse/disk_use.txt
cat ~/Projects/backups/openlist/open_list.txt
cat ~/Projects/backups/freedisk/free_disk.txt

#Bonus
#Command to copy system to system-wide cron directory
sudo cp ~/system.sh /etc/cron.weekly

#Step 4. Manage Log File Sizes
#Run sudo nano /etc/logrotate.conf to edit the logrotate configuration file.
# Configure a log rotation scheme that backs up authentication messages to the /var/log/auth.log.
/var/log/auth.log {
    weekly
    rotate 7
     notifempty
     delaycompress
     missingok
     endscript
}

#Bonus: Check for Policy and File Violations
#Command to verify auditd is active:
systemctl status auditd

#Command to set number of retained logs and maximum log file size
sudo nano /etc/audit/auditd.conf
#Edits made to the configuration file below:
num_logs = 7
max_log_file = 35

#Command using auditd to set rules for /etc/shadow, /etc/passwd and /var/log/auth.log:
sudo nano /etc/audit/rules.d/audit.rules
#Edits made to the rules file below:
-w /etc/shadow -p wra -k hashpass_audit
-w /etc/passwd -p wra -k userpass_audit
-w /var/log/auth.log -p wra -k authlog_audit

#Command to restart auditd:
sudo systemctl restart auditd

#Command to list all auditd rules:
sudo auditctl -l

#Command to produce an audit report:
aureport -au

#Create a user with sudo useradd attacker and produce an audit report that lists account modifications:
aureport -m

#Command to use auditd to watch /var/log/cron:
sudo auditctl -w /var/log/cron

#Command to verify auditd rules:
sudo auditctl -l

#Bonus (Research Activity): Perform Various Log Filtering Techniques
#Command to return journalctl messages with priorities from emergency to error:
journalctl -p “0..3”
#Or
journalctl -b -p “emerg”..”err”

#Command to check the disk usage of the system journal unit since the most recent boot:
sudo journalctl -u systemd-journald

#Comand to remove all archived journal files except the most recent two:
sudo journalctl --vacuum-files=2

#Command to filter all log messages with priority levels between zero and two, and save output to /home/sysadmin/Priority_High.txt:
sudo journalctl -p ‘0..2’ > /home/sysadmin/Priority_High.txt

#Command to automate the last command in a daily cronjob. With edits made to the crontab file below:
 0 20 * * * sudo journalctl -p ‘0..2’ > /home/sysadmin/Priority_High.txt
#Added to cron.daily script is Journal_Priority_High.txt