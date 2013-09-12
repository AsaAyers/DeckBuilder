###
Module dependencies.
###
express = require("express")
path = require("path")

module.exports = app = express()

# all environments
app.set "views", __dirname + "/views"
app.use app.router
app.use express.static(path.join(__dirname, "public"))

# development only
app.use express.errorHandler()  if "development" is app.get("env")


app.get "/", (req, res) ->
    console.log 'userX', req.user
    res.render 'index',
        user: req.user.toJSON()


