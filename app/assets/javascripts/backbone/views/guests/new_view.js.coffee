WeddingPrototype.Views.Guests ||= {}

class WeddingPrototype.Views.Guests.NewView extends Backbone.View
  template: JST["backbone/templates/guests/new"]

  events:
    "submit #new-guest-form": "save"

  constructor: (options) ->
    super(options)
    @model = new @collection.model()

    @model.bind("change:errors", () ->
      @render()
    )

  save: (e) ->
    e.preventDefault()
    e.stopPropagation()

    @model.unset("errors")

    #alert("saving!")

    @collection.create(@model.toJSON(),
      success: (guest) =>
        @model = guest
        #window.location.hash = "/#{@model.id}"
        @clearInputs()

      error: (guest, jqXHR) =>
        @model.set({errors: $.parseJSON(jqXHR.responseText)})
        alert @model.errors
    )

  clearInputs: =>
    @$("#new-guest-form").find(":input").each ->
      $(this).val("") unless this.type == "submit"

  render: ->
    @$el.html(@template(@model.toJSON() ))

    # defined in backbone-rails gem as an override for jQuery's backboneLink; provides change events for each input on any form it seems.
    @$("form").backboneLink(@model)

    return this