WeddingPrototype.Views.Invitations ||= {}

class WeddingPrototype.Views.Invitations.EditGuestsView extends Backbone.View
  template: JST["backbone/templates/invitations/edit_guests"]

  events:
    'click .edit-guests-link': 'editGuests'

  initialize: (options) ->
    @invitation = options.invitation
    @invitation.bind('guestsChanged', @updateGuests)

  updateGuests: (collection) =>
    console.log "In updateGuests"
    @invitation.set('guests', collection)
    @render()

  editGuests: =>
    @invitation.trigger('editGuests')

  render: =>
    @$el.html(@template(totalGuests: @invitation.get('guests').length))
    @$(".edit-guests-link").css("cursor", "pointer")

    return @