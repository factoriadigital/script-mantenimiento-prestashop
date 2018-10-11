#!/bin/bash

# Show log messages
VERBOSE=true

# Vars
ROOT_DIR="/home/" # Absolute path to this script
CACHE_EXPIRATION=60 # In days
CACHE_IMAGES_EXPIRATION=2 # In days
ERROR_LOG_MONTH_DAY=25 #Month day when error_log file will be removed

# Function declarations
function usage() 
{
    echo
    echo "Usage: $0"
    echo

    exit 1
}

function clean_themes_cache()
{
    for theme in $1/themes/*;
    do
        if [ -d "$theme/cache" ]; then
            find $theme/cache/ ! -name 'index.php' -type f -atime +$CACHE_EXPIRATION -exec rm -f {} \;
            show_log "Cleaned theme cache: $theme"
        fi        
    done
}

function clean_cache()
{
    show_log "Starting the clean cache images process..."

    if [ -d "$1/cache/smarty/compile/" ]; then
        find $1/cache/smarty/compile/ ! -name 'index.php' -type f -atime +$CACHE_EXPIRATION -exec rm -f {} \;
        show_log "Cleaned cache/smarty/compile/ files with access date greater than $CACHE_EXPIRATION days."
    else
        show_log "$1/cache/smarty/compile/ folder does not exist"
    fi

    if [ -d "$1/cache/smarty/cache/" ]; then
        find $1/cache/smarty/cache/ ! -name 'index.php' -type f -atime +$CACHE_EXPIRATION -exec rm -f {} \;    
        show_log "Cleaned cache/smarty/cache/ files with access date greater than $CACHE_EXPIRATION days."
    else
        show_log "$1/cache/smarty/cache/ folder does not exist"
    fi

    if [ -d "$1/cache/cachefs/" ]; then
        find $1/cache/cachefs/ -type f -atime +$CACHE_EXPIRATION -exec rm -f {} \;
        show_log "Cleaned cache/cachefs/ files with access date greater than $CACHE_EXPIRATION days."
    else
        show_log "$1/cache/cachefs/ folder does not exist"
    fi
        
    show_log "Clean cache process finished."
}

function clean_tmp_images()
{    
    if [ -d "$1/img/tmp/" ]; then
        find $1/img/tmp/ ! -name 'index.php' -type f -atime +$CACHE_IMAGES_EXPIRATION -exec rm -f {} \;
        show_log "Cleaned tmp images with access date greater than $CACHE_IMAGES_EXPIRATION days."
    else
        show_log "Skipping clean_tmp_images process: $1/img/tmp/ folder does not exist"
    fi
}

function clean_error_log_file()
{
    show_log "Cleaning error_log file..."

    monthDay=`date +%d`
    if [[ $monthDay -ge $ERROR_LOG_MONTH_DAY && -f "$1/error_log" ]]; then
        rm -f $1/error_log
        show_log "Cleaned"
    else
        show_log "Skipping clean error log file process: Not $ERROR_LOG_MONTH_DAY month day"
    fi

    show_log "Clean error_log file process finished."
}

function clean()
{
    show_log "-----------------------------------------------------------------------"
    show_log "Prestashop installation found on: $1"    
    clean_cache $1
    clean_themes_cache $1
    clean_tmp_images $1
    clean_error_log_file $1
    show_log "-----------------------------------------------------------------------"
}

function show_log()
{
    if [ "$VERBOSE" = true ]; then
        echo $1
    fi    
}

# For multiple Prestashop installations
for dir in *;
do
    # If Prestashop is found
    if [ -f "$ROOT_DIR$dir/public_html/config/settings.inc.php" ]; then    
        clean "$ROOT_DIR$dir/public_html"
    else
        for subdir in $ROOT_DIR$dir/public_html/*;
        do
            if [ -f "$subdir/config/settings.inc.php" ]; then
                clean "$subdir"
            fi
        done
    fi
done

# For a single Prestashop installation

# If Prestashop 1.6 is found
#if [ -f "$ROOT_DIRconfig/settings.inc.php" ]; then    
#    clean "$ROOT_DIR"
#else
#   for subdir in $ROOT_DIRpublic_html/*;
#   do
#       if [ -f "$subdir/config/settings.inc.php" ]; then
#           clean "$subdir"
#       fi
#   done
#fi
