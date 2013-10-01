$ = require('jquery')

apiRoot = 'http://deckbuilder.apiary.io'

$.ajaxSetup
    beforeSend: (req, settings) ->
        if settings.url[0] is '/'
            settings.url = "#{apiRoot}#{settings.url}"
        undefined
