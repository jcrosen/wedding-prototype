WeddingPrototype.Views.Guests ||= {}

class WeddingPrototype.Views.Guests.ShowView extends Backbone.View
  template: JST["backbone/templates/guests/show"]

  render: ->
    @$el.html(@template( @model.toJSON() ))
    return this
