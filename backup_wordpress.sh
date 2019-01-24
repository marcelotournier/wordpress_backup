#!/bin/bash

# THIS SCRIPT WAS DESIGNED TO BACKUP WORDPRESS (CONFIGURED WITH NGINX) SITE AND DATABASE.
# UPDATE THESE VALUES BELOW BEFORE RUNNING THIS SCRIPT.

# RUN THIS SCRIPT IN YOUR CLIENT (LOCAL) COMPUTER, FOR DOWNLOAD THE BACKUP FROM SERVER.

# TO RUN THIS CODE: "sudo source backup_wordpress.sh"

USER=PUT_YOUR_USER_NAME_HERE
MYSITE=PUT_YOUR_WORDPRESS_SITE_NAME_HERE

MYDB=PUT_YOUR_DATABASE_NAME_HERE
MYDB_USER=PUT_YOUR_DATABASE_USER_HERE
PUT_YOUR_DB_PASSWORD_HERE=PUT_YOUR_DATABASE_PASSWORD_HERE

# YOU (probably) DON'T NEED TO CHANGE THE SCRIPT BELOW...

MY_IP=$(dig +short inova.life) &&
COL='\033[0;31m' &&
NC='\033[0m' # No Color &&

echo -e ${COL}my IP: $MY_IP${NC} &&
#on my computer: 
mkdir ~/wp-backup &&
mkdir ~/wp-backup/$MYSITE &&
echo -e ${COL}copying sql backup to local machine...${NC} &&
ssh -t $USER@$MY_IP mysqldump -u $MYDB_USER -p$PUT_YOUR_DB_PASSWORD_HERE $MYDB > ~/wp-backup/$MYDB.sql &&
echo -e ${COL}copying nginx conf file to local machine...${NC} &&
sudo scp $USER@$MY_IP:/etc/nginx/sites-enabled/$MYSITE ~/wp-backup/$MYSITE_nginx_sites-enabled &&
echo -e ${COL}copying Wordpress backup to local machine...${NC} &&
sudo rsync -avz --human-readable --progress $USER@$MY_IP:/var/www/$MYSITE/ ~/wp-backup/$MYSITE || true &&
rm ~/wp-backup/$MYSITE/conf/nginx/ssl.conf
echo -e ${COL}compressing Wordpress backup...${NC} &&
zip -r wp-backup_$(date '+%d%b%Y').zip wp-backup &&
sudo rm -r ~/wp-backup
