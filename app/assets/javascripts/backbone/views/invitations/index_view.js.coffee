WeddingPrototype.Views.Invitations ||= {}

class WeddingPrototype.Views.Invitations.IndexView extends Backbone.View
  template: JST["backbone/templates/invitations/index"]

  render: ->
    @$el.html(@template())
    return this
