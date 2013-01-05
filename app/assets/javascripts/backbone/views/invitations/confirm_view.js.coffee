WeddingPrototype.Views.Invitations ||= {}

class WeddingPrototype.Views.Invitations.ConfirmView extends Backbone.View
  template: JST["backbone/templates/invitations/confirm"]

  render: ->
    @$el.html(@template())
    return this
