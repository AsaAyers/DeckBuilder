passport = require 'passport'
GoogleStrategy = require('passport-google').Strategy
Bookshelf = require 'bookshelf'

Bookshelf.Initialize
    client: 'mysql',
    connection:
        host     : 'localhost',
        user     : 'root',
        database : 'deck',
        charset  : 'utf8'


User = Bookshelf.Model.extend
    tableName: 'users'

Users = Bookshelf.Collection.extend
    model: User

console.log User::idAttribute



module.exports = (app) ->
    passport.serializeUser (user, done) ->
        user.save().then ->
            done null, user.id

    passport.deserializeUser (id, done) ->
        console.log 'deserialize', id
        (new User { id: id }).fetch().then (user) ->
            if user?
                done null, user
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
        returnURL: "http://deckbuilder.asaayers.com:5000/auth/google/return"
        realm: "http://deckbuilder.asaayers.com:5000/"
    , (identifier, profile, done) ->
        console.log identifier, profile

        { name: { familyName: last, givenName: first } } = profile

        (new User { open_id: identifier })
            .fetch().then (user) ->
                user ?= new User
                    name: "#{first} #{last}"
                    open_id: identifier
                user.save().then ->
                    done null, user
    )

