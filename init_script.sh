#!/bin/bash

if [ -f ".env" ]; then # scrip executed from repository root
    source .env
fi

echo "-- Ejecutando 'composer install'"
docker exec -i $APACHE_CONTAINER composer install --no-interaction --optimize-autoloader
echo "-- 'composer install' finalizado"

echo "-- Instalando framework toba"
docker exec -it $APACHE_CONTAINER bash -c "cd bin && export TOBA_INSTANCIA=desarrollo"
docker exec -it $APACHE_CONTAINER bash -c "cd bin && export TOBA_INSTALACION_DIR=/instalacion"
docker exec -it $APACHE_CONTAINER bash -c "cd bin && ./toba instalacion instalar -d /usr/local/proyectos/guarani"
echo "-- Framework toba instalado"

echo "-- Configurando permisos"
docker exec -it $APACHE_CONTAINER bash -c "chown -R root:www-data /usr/local/proyectos/guarani/www"
docker exec -it $APACHE_CONTAINER bash -c "chown -R root:www-data /usr/local/proyectos/guarani/temp"
docker exec -it $APACHE_CONTAINER bash -c "chown -R root:www-data /usr/local/proyectos/guarani/instalacion"
docker exec -it $APACHE_CONTAINER bash -c "chown -R root:www-data /usr/local/proyectos/guarani/vendor/siu-toba/framework/www"
docker exec -it $APACHE_CONTAINER bash -c "chown -R root:www-data /usr/local/proyectos/guarani/vendor/siu-toba/framework/temp"
docker exec -it $APACHE_CONTAINER bash -c "chown -R root:www-data www temp instalacion vendor/siu-toba/framework/www vendor/siu-toba/framework/temp"
docker exec -it $APACHE_CONTAINER bash -c "chmod 775 -R www temp instalacion vendor/siu-toba/framework/www vendor/siu-toba/framework/temp"

echo "-- Permisos configurados"

echo "-- Levantando configuracion de sitio"
docker exec -it $APACHE_CONTAINER bash -c "ln -s instalacion/toba.conf /etc/apache2/sites-available/toba_3_3.conf"
docker exec -it $APACHE_CONTAINER bash -c "service apache2 reload"
echo "-- Configuracion ok"


echo "-- Aplicando el fop"
docker exec -it $APACHE_CONTAINER bash -c "echo '[xslfo]' >> ./instalacion/instalacion.ini"
docker exec -it $APACHE_CONTAINER bash -c "echo 'fop=/usr/local/proyecto/guarani/php/3ros/fop/fop' >> ./instalacion/instalacion.ini"
echo "aplicado el fop"

echo "-- Cargando proyecto guarani"
docker exec -it $APACHE_CONTAINER bash -c "cd bin && ./guarani cargar -d /usr/local/proyectos/guarani"
echo "-- Proyecto guarani cargado"

echo "-- Apache2 restart"
docker exec -it $APACHE_CONTAINER bash -c "service apache2 reload"
echo "-- Apache2 restart ok"


echo "-- Instalando proyecto guarani"
docker exec -it $APACHE_CONTAINER bash -c "cd bin && ./guarani instalar"