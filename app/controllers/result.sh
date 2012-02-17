map "result" "/result"
result() {
   export NAME=$(param "name")
   export DATE=$(date)
   render_view "result"
}

