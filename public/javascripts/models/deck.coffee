Model = require '../base_model.coffee'

class Card extends Model

module.exports =
class Deck extends Model

    canAddCard: ->
        @validateForm('add_card', [ 'id', 'count' ], [], 'POST')

    addCard: (id, count=1) ->
        unless @canAddCard()
            throw new Error "Server doesn't meet expected requirements"

        card = new Card { id: id, count: count }

        { href: href, method: method } = @getForm 'add_card'
        card.save(undefined, { url: href, method: method }).then ->
            card
