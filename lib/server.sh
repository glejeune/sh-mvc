#!/bin/sh

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
   PREVIEW="DATA=\"$(cat $VIEW | sed -e 's/${\(.*\)}/$\1/')\""
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

route() {
   REQUEST=$1
   log "$REQUEST"

   ROUTE=$(echo $REQUEST | head -1 | awk '{print $2}')
   FILE=$(echo "$SH_MVC_STATIC/$ROUTE")

   if [ -f $FILE ] ; then
      render_file "$FILE"
   else
      ACTION=$(hget routes $ROUTE)
      if [ "x$ACTION" != "x" ] ; then
         eval $ACTION
      else
         render_data "<h1>$ROUTE : NOT FOUND!</h1>" "text/html"
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
