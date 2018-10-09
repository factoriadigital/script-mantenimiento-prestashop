
# Prestashop Maintenance Script por FactoriaDigital
![](https://img.shields.io/github/stars/factoriadigital/prestashop-maintenance-script.svg) ![](https://img.shields.io/github/forks/factoriadigital/prestashop-maintenance-script.svg) ![](https://img.shields.io/github/tag/factoriadigital/prestashop-maintenance-script.svg) ![](https://img.shields.io/github/release/factoriadigital/prestashop-maintenance-script.svg) ![](https://img.shields.io/github/issues/factoriadigital/prestashop-maintenance-script.svg) 

Estos scripts realizan la limpieza segura de los directorios de caché de Smarty /cache/smarty/compile y /cache/smarty/cache, así como del directorio /cache/cachefs y los directorios cache de los theme, por ejemplo /themes/default-bootstrap/cache/. 

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

#### Opciones adicionales
```bash 
VERBOSE=true
CACHE_EXPIRATION=180
CACHE_IMAGES_EXPIRATION=2
```
