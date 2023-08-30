# GUARANI3-DOCKER

Automatización de la instalación del SIU Guarani en un contenedor Docker.

## Instalación de Guarani3 - DOCKER

Asegúrate de tener Docker instalado en tu sistema antes de comenzar.

1. Clona este repositorio en tu máquina local:

   ```bash
   git clone https://github.com/tu-usuario/GUARANI3-DOCKER.git
   ```

2. Navega al directorio del repositorio:
   ```bash
      cd GUARANI3-DOCKER
   ```

3. Define las siglas de tu institución y la versión de Guarani que deseas instalar:
    ```bash
   siglas_institucion=uba-ffyl
   version=3.21.0
   ```
4. Ejecuta el comando para traer el GUARANI:
     ```bash     
    svn checkout https://colab.siu.edu.ar/svn/guarani3/nodos/$siglas_institucion/gestion/trunk/$version guarani
     ```

5. Ejecuta el siguiente comando para iniciar el contenedor Docker y ejecutar el script de inicialización:
    ```bash
     docker-compose up -d && ./init_script.sh     
    ```

# Contribuciones
¡Las contribuciones son bienvenidas! Si deseas colaborar, puedes enviar pull requests con tus mejoras.

- [Ivan Aguirre](https://github.com/aguirre-ivan)
  
- [Nazareno Fiorentino](https://github.com/nazafiorentino)
  
- [Facundo Lepere](https://github.com/facundolepere)

