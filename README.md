
# Prestashop Maintenance Script por FactoriaDigital
![](https://img.shields.io/github/stars/factoriadigital/prestashop-maintenance-script.svg) ![](https://img.shields.io/github/forks/factoriadigital/prestashop-maintenance-script.svg) ![](https://img.shields.io/github/tag/factoriadigital/prestashop-maintenance-script.svg) ![](https://img.shields.io/github/release/factoriadigital/prestashop-maintenance-script.svg) ![](https://img.shields.io/github/issues/factoriadigital/prestashop-maintenance-script.svg) 

Estos scripts realizan la limpieza segura de los directorios de caché de Smarty /cache/smarty/compile y /cache/smarty/cache, así como del directorio /cache/cachefs y los directorios cache de los theme, por ejemplo /themes/default-bootstrap/cache/.
Se eliminarán los archivos los cuales no se hayan utilizado/accedido en los días definidos en la variable `CACHE_EXPIRATION`, la cual por defecto se establece a 60 días.

Adicionalmente, se procederán a eliminar las imágenes en el directorio temporal de las mismas /img/tmp/, las cuales no se hayan utilizado/accedido en los días definidos en la variable `CACHE_IMAGES_EXPIRATION`, la cual por defecto se establece a 2 días.

Se establece un día del mes (o superior al indicado) para que se proceda al borrado del archivo error_log, el cual en ocasiones puede llenarse en exceso. Es importante revisar estos errores, puesto que los que aparecen en este archivo, son errores relevantes, por lo que no deberíamos simplemente borrar el archivo e ignorarlos. El día del mes por defecto es el 25, se indica en la variable `ERROR_LOG_MONTH_DAY`. Hay que tener en cuenta que no todos los meses tienen 30 ni 31 días, y en el caso de Febrero el caso es aún más concreto, por lo que hay que proceder con cautela al configurar este valor.

## Método de uso

#### Múltiples Prestashop
Si deseas utilizar el script para múltiples Prestashop, debes editar la variable
```javascript
ROOT_DIR = "/home/"
```
Con la ruta absoluta desde donde tengas localizado este script y desde donde se puedan encontrar los demás directorios/cuentas de Prestashop. 

Por ejemplo, podríamos tener lo siguiente:

```
/home/cliente1/public_html/
/home/cliente2/public_html/
```

Por los que el script iría en `/home/prestashop<version>_maintenance.sh` para que detectara cada directorio y realizara automáticamente la limpieza en ellos.

#### Un único Prestashop

Deberás añadir la ruta absoluta hacia el root de tu directorio Prestashop en la siguiente variable:
```bash
ROOT_DIR = "/home/usuario/public_html/"
```
Introducir este script dentro de ese mismo directorio y modificar las últimas líneas del script, actualmente son así:
```bash
# For multiple Prestashop installations
for dir in *;
do
    # If Prestashop is found
    if [ -f "$ROOT_DIR$dir/public_html/config/settings.inc.php" ]; then    
        clean "$ROOT_DIR$dir/public_html"
    fi
done

# For a single Prestashop installation

# If Prestashop is found
#if [ -f "$ROOT_DIRconfig/settings.inc.php" ]; then    
#    clean "$ROOT_DIR"
#fi
```
Descomentaremos las líneas de abajo, las cuales validan la instalación para una única instalación de Prestashop y comentaremos de la misma forma las líneas superiores para dejar intacto el proceso para múltiples Prestashop, quedando algo así:

```bash
# For multiple Prestashop installations
#for dir in *;
#do
    # If Prestashop is found
#    if [ -f "$ROOT_DIR$dir/public_html/config/settings.inc.php" ]; then    
#        clean "$ROOT_DIR$dir/public_html"
#    fi
#done

# For a single Prestashop installation

# If Prestashop is found
if [ -f "$ROOT_DIRconfig/settings.inc.php" ]; then    
    clean "$ROOT_DIR"
fi
```
#### Ejecutar el script

Otorgamos permisos de ejecución al script accediendo desde el servidor:
```bash
chmod +x prestashop<version>_maintenance.sh
```
Y lanzamos el script 
```bash
./prestashop<version>_maintenance.sh
```
El script comenazará a escanear los directorios y a proceder con su limpieza.

#### Ejecutar el script de forma periodica

Podemos ejecutar el script de forma periodica para que realice las tareas de mantenimiento necesarias mediante una tarea cron. Para ello, desde la cuenta de cPanel, accedemos a "Tareas cron" o "Cron Jobs", donde encontraremos una serie de opciones para programar la tarea.

Dependiendo de donde esté el script subido, la ruta será una u otra, para este ejemplo, contamos que el script está subido a /home, para que detecte todos los Magento que podamos tener instalados y así realice la limpieza de todos a la vez, por tanto, la línea a introducir para el comando de la tarea cron será:

```/bin/sh /home/prestashop16_maintenance.sh```

Si queremos que se ejecute una vez a la semana, el sábado a las 2AM, los valores del cron serán:

```0 2 * * 6```

Quedando la línea completa así:

```0 2 * * 6 /bin/sh /home/prestashop16_maintenance.sh```

Es importante tener en cuenta que la ruta de instalación del cron ha de ser la misma que la de la variable ROOT_DIR del script, siendo por tanto ROOT_DIR/nombre del script.sh, sino no se ejecutará correctamente.

Se pueden ver de manera visual en qué momentos se ejecutarán las tareas cron en esta página web: https://crontab.guru/#0_2_*_*_6

#### Opciones adicionales
```bash 
VERBOSE=true
CACHE_EXPIRATION=60
CACHE_IMAGES_EXPIRATION=2
ERROR_LOG_MONTH_DAY=25
```
