map "get_test" "/test"
get_test() {
   export DATE=$(date)
   render_view "test"
}

