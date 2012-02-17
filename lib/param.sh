parse_params() {
   __DATA=$1; shift
   __PAIR=$(echo $__DATA | cut -d"&" -f1)
   while [ "x$__DATA" != "x" ]; do
      __KEY=$(trim $(echo $__PAIR | awk -F"=" '{print $1}'))
      __VALUE=$(trim $(echo $__PAIR | sed -e "s/$__KEY=//"))
      hput "params" "$__KEY" "$__VALUE"
      __DATA=$(echo $__DATA | sed -e "s/$__PAIR//" | sed -e 's/^&//')
      __PAIR=$(echo $__DATA | cut -d"&" -f1)
   done
}

param() {
   hget "params" "$1"
}
