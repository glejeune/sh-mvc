redirect() {
   LOCATION=$1
   cat >$RESP <<EOF
HTTP/1.0 302 OK
Content-Type: text/plain
Server: bash/2.0
Connection: Close
Location: $LOCATION

EOF
}

render_view() {
   VIEW=$SH_MVC_APP/views/$1.esh
   PREVIEW="DATA=\"$(cat $VIEW | sed -e 's/"/\\"/g' | sed -e 's/${\(.*\)}/$\1/g')\""
   eval $PREVIEW
   render_data "$DATA"
}

render_data() {
   DATA="$1"
   MIME_TYPE="$2"
   if [ "x$MIME_TYPE" == "x" ] ; then
      MIME_TYPE="text/html"
   fi

   cat >$RESP <<EOF
HTTP/1.0 200 OK
Cache-Control: private
Content-Type: $MIME_TYPE
Server: bash/2.0
Connection: Close
Content-Length: ${#DATA}

$DATA
EOF
}

render_file() {
   FILE="$1"
   FILE_SIZE=$(stat -f"%z" $FILE)
   FILE_TYPE=$(file $FILE | awk '{print $2}')
   MIME_TYPE=$(hget types $FILE_TYPE)
   cat >$RESP <<EOF <$FILE
HTTP/1.1 200 OK
Cache-Control: private
Content-Type: $MIME_TYPE
Server: bash/2.0
Connection: Close
Content-Length: ${FILE_SIZE}

EOF
}

parse_header() {
   __DATA=$(echo "$1" | tr -d '\n' | tr -d '\r') ; shift
   if [ "x$__ROUTE" == "x" ] ; then
      parse_route $(echo $__DATA | awk '{print $2}')
   else
      __KEY=$(trim $(echo $__DATA | awk -F":" '{print $1}'))
      __VALUE=$(trim $(echo $__DATA | sed -e "s/$__KEY://"))
      hput "header" "$__KEY" "$__VALUE"
   fi
}

route() {
   REQUEST="$1"

   while read __LINE ; do
      parse_header "$__LINE"
   done <<EOF
"$REQUEST"
EOF

   __CL=$(hget "header" "Content-Length")
   if [ "x$__CL" != "x" ] ; then
      read -n $__CL __BODY
      parse_params "$__BODY"
   fi

   log "$REQUEST"

   FILE=$(echo "$SH_MVC_STATIC/$__ROUTE")

   if [ -f $FILE ] ; then
      render_file "$FILE"
   else
      ACTION=$(hget routes $__ROUTE)
      if [ "x$ACTION" != "x" ] ; then
         eval $ACTION
      else
         render_data "<h1>$__ROUTE : NOT FOUND!</h1>" "text/html"
      fi
   fi
}

run() {
   RESP=$SH_MVC_TMP/shmvc.http.$$
   [ -p $RESP ] || mkfifo $RESP

   echo "** start server on port $PORT"
   while true ; do
      ( cat $RESP ) | nc -l $PORT | (
         REQ=`while read L && [ " " "<" "$L" ] ; do echo "$L" ; done`
         route "$REQ"
      )
   done
}

stop() {
   echo "** stop server"
   rm -f $RESP
}

trap 'stop; exit' INT
