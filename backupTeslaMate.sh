#!/bin/bash
#
# Description: Script para hacer backup de la base de datos de TeslaMate
#
# Author: Carlos Cuezva
# Created: 23/04/2021

PATH_COMPOSE=$HOME
PATH_BACKUP=$HOME/TeslaMateBackup

echo -e '\n---- Comenzando el backup ----\n'

cd $PATH_COMPOSE
FILENAME=`date +"%Y%m%d"`_teslamate.bck
docker-compose exec -T database pg_dump -U teslamate teslamate > $PATH_BACKUP/$FILENAME

cd $PATH_BACKUP
gzip -9 -f $FILENAME

FILESIZE=`du -h "$FILENAME.gz" | cut -f1`
echo -e "\nLa copia de seguridad tiene un tamaño de $FILESIZE\n"

echo -e '\n---- Finalizado el backup ----\n'