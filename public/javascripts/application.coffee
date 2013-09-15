# These need to be exposed globally so Marionette can pick them up.
window.jQuery = window.$ = require('jquery')
window._ = require 'underscore'
window.Backbone = require 'backbone'

# Browserify actually prevents Backbone from reaching the real global object,
# so jQuery has to be added here.
Backbone.$ = $
Marionette = require 'marionette'

console.log 'hello world'
ApiClient = require './api_client.coffee'
window.api = api = new ApiClient
api.fetch().done ->
    api.createDeck("Goblins")
