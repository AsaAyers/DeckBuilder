passport = require 'passport'
GoogleStrategy = require('passport-google').Strategy


module.exports = (app) ->
    users = {}
    passport.serializeUser (user, done) ->
        user.id ?= Math.random()
        users[user.id] = user
        done null, user.id

    passport.deserializeUser (id, done) ->
        if users[id]?
            done null, users[id]
        else
            done "user not found"

    # Redirect the user to Google for authentication.  When complete, Google
    # will redirect the user back to the application at
    #     /auth/google/return
    app.get('/auth/google', passport.authenticate('google'))

    # Google will redirect the user to this URL after authentication.  Finish
    # the process by verifying the assertion.  If valid, the user will be
    # logged in.  Otherwise, authentication has failed.
    app.get('/auth/google/return',
        passport.authenticate('google', {
            successRedirect: '/',
            failureRedirect: '/login' }
        )
    )

    passport.use new GoogleStrategy(
        returnURL: "http://localhost:3000/auth/google/return"
        realm: "http://localhost:3000/"
    , (identifier, profile, done) ->
        console.log identifier, profile
        user =
            openId: identifier
        done null, user
    )

