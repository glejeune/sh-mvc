map "index" "/index"
index() {
   export DATE=$(date)
   render_view "index"
}

