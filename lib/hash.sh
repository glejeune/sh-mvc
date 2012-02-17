hput() {
   DOMAIN=$1
   KEY=$(echo $2 | sed -e 's/\//___/g' | sed -e 's/-/___/g')
   VALUE=$3
   eval "$DOMAIN""$KEY"='$VALUE'
}

hget() {
   DOMAIN=$1
   KEY=$(echo $2 | sed -e 's/\//___/g' | sed -e 's/-/___/g')
   eval echo '${'"$DOMAIN$KEY"'}' 
}

