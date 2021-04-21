#!/bin/bash
#
# Description: Script para restaurar la base de datos de TeslaMate
#
# Author: Carlos Cuezva
# Created: 21/04/2021

PATH_COMPOSE=$HOME
PATH_BACKUP=$1

if [ ! -f "$PATH_BACKUP" ]; then
    echo -e '\nEl archivo de backup no existe\n'
    exit 1
fi

if  [[ $PATH_BACKUP == ..* ]] ;
then
    PATH_BACKUP=`realpath $PATH_BACKUP`
fi

echo -e '\n---- Detenemos la instancia de TeslaMate ----\n'
cd $PATH_COMPOSE
docker-compose stop teslamate

echo -e  '\n¿Deseas BORRAR la base de datos actual de TeslaMate (s/n)? '
read answer
if [ "$answer" != "${answer#[Ss]}" ] ;then
    docker-compose exec -T database psql -U teslamate << .
drop schema public cascade;
create schema public;
create extension cube;
create extension earthdistance;
CREATE OR REPLACE FUNCTION public.ll_to_earth(float8, float8)
    RETURNS public.earth
    LANGUAGE SQL
    IMMUTABLE STRICT
    PARALLEL SAFE
    AS 'SELECT public.cube(public.cube(public.cube(public.earth()*cos(radians(\$1))*cos(radians(\$2))),public.earth()*cos(radians(\$1))*sin(radians(\$2))),public.earth()*sin(radians(\$1)))::public.earth';
.
fi

echo -e '\n---- Restauramos en backup ----\n'
docker-compose exec -T database psql -U teslamate -d teslamate < $PATH_BACKUP

echo -e '\n---- Iniciamos la instancia de TeslaMate ----\n'
docker-compose start teslamate