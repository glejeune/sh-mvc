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
