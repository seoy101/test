#!/bin/sh
cd /imageRepo
SERVER="192.168.0.136"
USER="buff"
PASS="1111"
ftp -in $SERVER 50021<<EOF
passive
user $USER $PASS
mput *
bye
EOF
