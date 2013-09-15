Deck = require './models/deck.coffee'
Model = require './base_model.coffee'

module.exports =
class ApiClient extends Model

    # This simplifies the permissions process. The client doesn't care why it
    # can't create a new deck. Maybe you're viewing someone else's deck? Maybe
    # a service that creating decks depends on is down? It doesn't matter.
    canCreateDeck: ->
        @validateForm('new_deck', [ 'name' ], [], 'POST')

    createDeck: (name) ->
        unless @canCreateDeck()
            throw new Error "Server doesn't meet expected requirements"

        deck = new Deck { name: name }

        { href: href, method: method } = @getForm 'new_deck'
        deck.save undefined, { url: href, method: method }
