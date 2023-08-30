#!/bin/bash

if [ -f ".env" ]; then
    source .env
fi


animate_loading() {
    local chars="/-\|"
    for (( i=0; i<5; i++ )); do
        echo -ne "\\e[1m$1 [${chars:$i:1}]\\e[0m\r"
        sleep 0.2
    done
    echo -e "\\e[1m$1 [Done]\\e[0m"
    sleep 1.5 
}


animate_loading "-- Ejecutando 'composer install'"
docker exec -i $APACHE_CONTAINER composer install --no-interaction --optimize-autoloader


animate_loading "-- Instalando framework toba"
docker exec -it $APACHE_CONTAINER bash -c "cd bin && export TOBA_INSTANCIA=desarrollo"
docker exec -it $APACHE_CONTAINER bash -c "cd bin && export TOBA_INSTALACION_DIR=/instalacion"
docker exec -it $APACHE_CONTAINER bash -c "cd bin && ./toba instalacion instalar -d /usr/local/proyectos/guarani"

animate_loading "-- Configurando permisos"
docker exec -it $APACHE_CONTAINER bash -c "chown -R root:www-data /usr/local/proyectos/guarani/www"
docker exec -it $APACHE_CONTAINER bash -c "chown -R root:www-data /usr/local/proyectos/guarani/temp"
docker exec -it $APACHE_CONTAINER bash -c "chown -R root:www-data /usr/local/proyectos/guarani/instalacion"
docker exec -it $APACHE_CONTAINER bash -c "chown -R root:www-data /usr/local/proyectos/guarani/vendor/siu-toba/framework/www"
docker exec -it $APACHE_CONTAINER bash -c "chown -R root:www-data /usr/local/proyectos/guarani/vendor/siu-toba/framework/temp"
docker exec -it $APACHE_CONTAINER bash -c "chown -R root:www-data www temp instalacion vendor/siu-toba/framework/www vendor/siu-toba/framework/temp"
docker exec -it $APACHE_CONTAINER bash -c "chmod 775 -R www temp instalacion vendor/siu-toba/framework/www vendor/siu-toba/framework/temp"


animate_loading "-- Levantando configuracion de sitio"
docker exec -it $APACHE_CONTAINER bash -c "ln -s instalacion/toba.conf /etc/apache2/sites-available/toba_3_3.conf"
docker exec -it $APACHE_CONTAINER bash -c "service apache2 reload"


animate_loading "-- Aplicando el fop"
docker exec -it $APACHE_CONTAINER bash -c "echo '[xslfo]' >> ./instalacion/instalacion.ini"
docker exec -it $APACHE_CONTAINER bash -c "echo 'fop=/usr/local/proyecto/guarani/php/3ros/fop/fop' >> ./instalacion/instalacion.ini"

animate_loading "-- Cargando proyecto guarani"
docker exec -it $APACHE_CONTAINER bash -c "cd bin && ./guarani cargar -d /usr/local/proyectos/guarani"

animate_loading "-- Apache2 restart"
docker exec -it $APACHE_CONTAINER bash -c "service apache2 reload"


animate_loading "-- Proyecto guarani instalado"
docker exec -it $APACHE_CONTAINER bash -c "cd bin && ./guarani instalar"


animate_loading "-- Dando permisos nuevamente"
docker exec -it $APACHE_CONTAINER bash -c "chown -R root:www-data /usr/local/proyectos/guarani/www"
docker exec -it $APACHE_CONTAINER bash -c "chown -R root:www-data /usr/local/proyectos/guarani/temp"
docker exec -it $APACHE_CONTAINER bash -c "chown -R root:www-data /usr/local/proyectos/guarani/instalacion"
docker exec -it $APACHE_CONTAINER bash -c "chown -R root:www-data /usr/local/proyectos/guarani/vendor/siu-toba/framework/www"
docker exec -it $APACHE_CONTAINER bash -c "chown -R root:www-data /usr/local/proyectos/guarani/vendor/siu-toba/framework/temp"
docker exec -it $APACHE_CONTAINER bash -c "chown -R root:www-data www temp instalacion vendor/siu-toba/framework/www vendor/siu-toba/framework/temp"
docker exec -it $APACHE_CONTAINER bash -c "chmod 775 -R www temp instalacion vendor/siu-toba/framework/www vendor/siu-toba/framework/temp"
