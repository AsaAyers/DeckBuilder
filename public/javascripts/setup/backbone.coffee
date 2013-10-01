Q = require 'q'
_ = require 'underscore'
Backbone = require 'backbone'

_.wrap Backbone.sync, (oSync, args...) ->
    Q.when(oSync.apply(Backbone, args))
