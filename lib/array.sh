asize() {
   __DOMAIN=$1
   __N=$(eval echo '${'"$__DOMAIN""__NN"'}')
   if [ "x$__N" == "x" ] ; then
      __N=-1
   fi

   echo $((__N+1))
}

aput() {
   __DOMAIN=$1
   __VALUE=$2
   __N=$(eval echo '${'"$__DOMAIN""__NN"'}')
   if [ "x$__N" == "x" ] ; then
      __N=0
   else
      __N=$((__N+1))
   fi
   eval "$__DOMAIN""__NN"='$__N'
   eval "$__DOMAIN""__""$__N"='$__VALUE'
}

aget() {
   __DOMAIN=$1
   __INDEX=$2
   eval echo '${'"$__DOMAIN""__""$__INDEX"'}'
}

aclean() {
   __DOMAIN=$1
   __N=$(asize $__DOMAIN)
   __N=$((__N-1))
   for i in {0..$__N} ; do
      unset "$__DOMAIN""__""$i"
   done
   unset "$__DOMAIN""__N"
}
