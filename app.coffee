
###
Module dependencies.
###
express = require("express")
http = require("http")
path = require("path")
app = express()
passport = require 'passport'
setupPassport = require './setup/passport'
hbs = require('hbs')

# all environments
app.set "port", process.env.PORT or 3000
app.set "views", __dirname + "/views"

# This will use handlebars, but the files end in .html.  This is mostly so vim
# can do better syntax highlighting.
app.set "view engine", "html"
app.engine 'html', hbs.__express

app.use express.favicon()
app.use express.logger("dev")
app.use express.bodyParser()
app.use express.methodOverride()
app.use express.cookieParser("your secret here")
app.use express.session()
app.use passport.initialize()
app.use passport.session()
app.use app.router
app.use require("less-middleware")(src: __dirname + "/public")
app.use express.static(path.join(__dirname, "public"))

hbs.registerPartials __dirname + "/views/partials"
setupPassport app


ensureAuthenticated = (req, res, next) ->
    return next() if req.isAuthenticated()
    res.redirect '/'

app.use '/app', ensureAuthenticated
app.use '/app', require('./lib/app')


# development only
app.use express.errorHandler()  if "development" is app.get("env")
app.get "/", (req, res) ->
    console.log 'root user', req.user
    if req.user?
        res.redirect '/app'
    else
        res.render 'index'

http.createServer(app).listen app.get("port"), ->
    console.log "Express server listening on port " + app.get("port")

