# SH-MVC aka Shails
A (very) naive MVC framework

## How to install

Just clone the repo :

    git clone https://github.com/glejeune/sh-mvc.git

Then, run the server :

    cd sh-mvc
    ./bin/serve

And go to `http://localhost:9000` 

## Add a controller

To add a controller, create a `.sh` file in `app/controllers`. In this file, you can define actions by creating functions :

    # app/controllers/sample.sh
    sample_action() {
        # ...
    }

Then you must map each action to one or more routes :

    # app/controllers/sample.sh
    sample_action() {
        # ...
    }
    map "sample_action" "/sample" 

The first parameter of the `map` function is the name of the function, the following parameters are the routes to map to. In this example, when you go to `http://localhost:9000/sample`, *Shails* will call `sample_action`.

In an action, you can retrieve the GET or POST parameters by using `param`. This function take the name of the parameter you want to retrieve the value.

    # app/controllers/sample.sh
    sample_action() {
        USERNAME=$(param "username")
        # ...
    }
    map "sample_action" "/sample" 

## Add a view

Views are created by adding `.esh` files in `app/views`. A view file is an HTML file in which you evaluate a variable by using `${...}` :

    <!-- app/views/sample_view.esh -->
    <html>
      <body>
        <h1>Hello ${USERNAME}</h1>
        <p>It's <b>${DATE}</b></p>
      </body>
    </html>
 
Now you can declate `DATE` in your controller and ask rendering this view, by using `render_view` :

    # app/controllers/sample.sh
    sample_action() {
        export USERNAME=$(param "username")
        export DATE=$(date)
        
        render_view "sample_view"
    }
    map "sample_action" "/sample" 

> Code evaluation is not yet supported in views... Thanks for your help ;)
