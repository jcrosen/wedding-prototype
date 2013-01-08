WeddingPrototype.Views.Guests ||= {}

class WeddingPrototype.Views.Guests.ShowView extends Backbone.View
  template: JST["backbone/templates/guests/show"]

  events:
    "click .destroy" : "destroy"

  destroy: () ->
    @model.destroy()
    this.remove()

    return false

  render: ->
    @$el.html(@template( @model.toJSON() ))
    return this
