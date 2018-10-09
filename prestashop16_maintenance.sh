#!/bin/bash

# Show log messages
VERBOSE=true

# Vars
ROOT_DIR="/home/" # Absolute path to this script
CACHE_EXPIRATION=60 # In days
CACHE_IMAGES_EXPIRATION=2 # In days

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
    find $1/cache/smarty/compile/ ! -name 'index.php' -type f -atime +$CACHE_EXPIRATION -exec rm -f {} \;
    find $1/cache/smarty/cache/ ! -name 'index.php' -type f -atime +$CACHE_EXPIRATION -exec rm -f {} \;    
    find $1/img/tmp/ ! -name 'index.php' -type f -atime +$CACHE_IMAGES_EXPIRATION -exec rm -f {} \;
    show_log "Cleaned tmp images with access date greater than $CACHE_IMAGES_EXPIRATION days."
    find $1/cache/cachefs/ -type f -atime +$CACHE_EXPIRATION -exec rm -f {} \;
    show_log "Cleaned smarty cache with access date greater than $CACHE_EXPIRATION days."
    clean_themes_cache $1
    show_log "Clean cache process finished."
}

function clean()
{
    show_log "-----------------------------------------------------------------------"
    show_log "Prestashop installation found on: $1"    
    clean_cache $1
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
    fi
done

# For a single Prestashop installation

# If Prestashop 1.6 is found
#if [ -f "$ROOT_DIRconfig/settings.inc.php" ]; then    
#    clean "$ROOT_DIR"
#fi
