WeddingPrototype.Views.Guests ||= {}

class WeddingPrototype.Views.Guests.ModalIndexView extends Backbone.View
  template: JST["backbone/templates/guests/modal_index"]
  events:
    "click .done-button": "hideModal"

  initialize: (options) ->
    options ||= {}
    @invitation = options.invitation
    @cssId = options.cssId or "invitation-guests-modal"

  prepare: (options) =>
    @invitation = options.invitation or @invitation
    @guests = new WeddingPrototype.Collections.Guests(invitation: @invitation)
    @setEventTitle()
    @guests.bind('reset', @addGuests)
    @guests.bind('reset', @addNewView)
    @guests.bind('reset', @addPreviousGuests)
    @guests.bind('add', @addGuest)

  setEventTitle: =>
    @$('.event-title-span').html(@invitation.get('event').title)

  hideModal: =>
    @modal('hide')

  modal: (action) =>
    options = action
    if not options
      options = keyboard: true
    $("##{@cssId}").modal(options)

  addPreviousGuests: =>
    @$("#previous-guests").html("")
    _.each(@invitation.get('other_guests_list'), @addPreviousGuest)

  addPreviousGuest: (previousGuest) =>
    view = new WeddingPrototype.Views.Guests.AddPreviousView(guest: previousGuest, collection: @guests)
    @$("#previous-guests").append(view.render().el)

  addGuests: () =>
    @$("#guests").html("")
    @guests.each(@addGuest)
    @$('i').css("cursor", "pointer")

  addGuest: (guest) =>
    view = new WeddingPrototype.Views.Guests.ShowView(guest: guest, invitation: @invitation)
    @$("#guests").append(view.render().el)

  addNewView: (guests) =>
    view = new WeddingPrototype.Views.Guests.NewView(invitation: @invitation, collection: guests)
    @$("#new-guest").html(view.render().el)

  renderModal: =>
    @render(template: @modalTemplate)

  render: () =>
    @$el.html(@template(cssId: @cssId))
    return this