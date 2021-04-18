#!/bin/bash
#
# Description: 
#
# Author: Carlos Cuezva
# Created: 18/04/2021

echo '¿Deseas hacer una copia de seguridad de la base de datos (s/n)? '
read answer

if [ "$answer" != "${answer#[Ss]}" ] ;then
    filename=`date +"%Y%m%d"`_teslamate.bck
    docker-compose exec -T database pg_dump -U teslamate teslamate > ./$filename
fi

echo '\n---- Comenzando la actualización ----\n'
docker-compose pull
echo '\n---- Finalizada la actualización ----\n'

echo '\n---- Reiniciando docker de TeslaMate ----\n'
docker-compose up -d