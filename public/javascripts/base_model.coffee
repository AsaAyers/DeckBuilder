Backbone = require 'backbone'

module.exports =
class Model extends Backbone.Model
    parse: (data) ->
        console.log 'parse', data
        _.defaults data,
            _links: {}
            forms: {}
            _embedded: {}
        @_links = data._links
        @_forms = data.forms
        @_embedded = data._embedded

        if data._links.self?
            @url = data._links.self.href

        delete data._links
        delete data.forms
        delete data._embedded

        data

    hasForm: (name) -> @_forms[name]?

    getForm: (name) ->
        # Clone the form
        f = _.defaults {}, @_forms[name], {fields: {}, optional_fields: {}}
        _.extend f, @getLink(f.link)

    getLink: (name) ->
        _.defaults {}, @_links[name], { method: 'GET' }

    submitForm: (name, fields) ->
        unless @hasForm(name)
            throw new Error "form missing"
        form = @getForm name

    validateForm: (name, fields, optional_fields, method = 'GET') ->
        return false unless @_forms[name]?
        form = @getForm name
        return false unless form? or form?.href

        # Every required field is present in the fields this client knows
        # about.
        if _.every(form.fields, (f) -> f in fields)
            return true

        # TODO: What if the server has stopped accepting a field?
        # TODO: How should optional_fields be validated?

        return form.method is method
