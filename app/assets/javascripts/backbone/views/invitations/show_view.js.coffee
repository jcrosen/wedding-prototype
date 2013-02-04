WeddingPrototype.Views.Invitations ||= {}

class WeddingPrototype.Views.Invitations.ShowView extends Backbone.View
  template: JST["backbone/templates/invitations/show"]

  events:
    "click #edit-status-button": "makeStatusEditable"

  initialize: (options) ->
    @model = options.model
    @model.bind('statusConfirmed', @resetStatus)

  makeStatusEditable: =>
    confirm_view = new WeddingPrototype.Views.Invitations.ConfirmView(model: @model)
    @$("#invitation-status-text").html(confirm_view.render().el)

  resetStatus: =>
    @$("#invitation-status-text").html("#{@model.get("printable_status")}")

  render: =>
    @$el.html(@template( @model.toJSON() ))
    return this
