parse_route() {
   __TMP=$1 ; shift
   __ROUTE=$(trim $(echo $__TMP | awk -F'?' '{print $1}'))
   __ROUTE_REG=$(echo $__ROUTE | sed -e 's/\//\\\//g')
   __PARAMS=$(trim $(echo $__TMP | sed -e "s/^$__ROUTE_REG//"))
   __PARAMS=$(echo $__PARAMS | sed -e 's/^\?//')
   if [ "x$__PARAMS" != "x" ] ; then
      parse_params "$__PARAMS"
   fi
}

map() {
   ACTION=$1; shift
   ROUTE=$1; shift
   while [ "x$ROUTE" != "x" ] ; do
      echo "** Assign route '$ROUTE' to controller '$ACTION'"
      hput routes "$ROUTE" "$ACTION"
      ROUTE=$1; shift
   done
}

for i in $(find $SH_MVC_APP/controllers -name "*.sh") ; do
   . $i
done
