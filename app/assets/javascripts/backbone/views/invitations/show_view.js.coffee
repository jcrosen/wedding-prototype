WeddingPrototype.Views.Invitations ||= {}

class WeddingPrototype.Views.Invitations.ShowView extends Backbone.View
  template: JST["backbone/templates/invitations/show"]

  events:
    "click #invitation-status": "makeStatusEditable"

  initialize: (options) ->
    @model = options.model
    @model.bind('statusConfirmed', @render)

  makeStatusEditable: ->
    confirm_view = new WeddingPrototype.Views.Invitations.ConfirmView(model: @model)
    @$("#invitation-status-text").html(confirm_view.render().el)

  render: ->
    @$el.html(@template( @model.toJSON() ))
    return this
