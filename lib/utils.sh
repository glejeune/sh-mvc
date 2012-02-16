#!/bin/sh

hput() {
   DOMAIN=$1
   KEY=$(echo $2 | sed -e 's/\//___/')
   VALUE=$3
   eval "$DOMAIN""$KEY"='$VALUE'
}

hget() {
   DOMAIN=$1
   KEY=$(echo $2 | sed -e 's/\//___/')
   eval echo '${'"$DOMAIN$KEY"'}' 
}

log() {
   echo "[`date '+%Y-%m-%d %H:%M:%S'`] $1" | head -1
}

