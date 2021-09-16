#!/bin/bash
#
# Description: Script para actualizar TeslaMate
#
# Author: Carlos Cuezva
# Created: 18/04/2021
# Last update: 16/09/2021

PATH_SCRIPT=`pwd`
PATH_COMPOSE=$HOME

echo '¿Deseas hacer una copia de seguridad de la base de datos (s/n)? '
read answer

if [ "$answer" != "${answer#[Ss]}" ] ;then
    $PATH_SCRIPT/backupTeslaMate.sh
fi

cd $PATH_COMPOSE
echo -e '\n---- Comenzando la actualización ----\n'
docker-compose pull
echo -e '\n---- Finalizada la actualización ----\n'

echo -e '\n---- Reiniciando docker ----\n'
docker-compose up -d
echo -e '\n---- Reinicio completado ----\n'