WeddingPrototype.Views.Invitations ||= {}

class WeddingPrototype.Views.Invitations.ConfirmationView extends Backbone.View
  template: JST["backbone/templates/invitations/confirmation"]

  events:
    "click .btn-not-attending": "notAttending"
    "click .btn-attending": "attending"
    "click .reset-status": "resetStatus"

  initialize: (options) ->
    @invitation = options.invitation

  attending: =>
    new_status = 'attending'
    if @invitation.get('status') != new_status
      @confirm(new_status)

  notAttending: =>
    new_status = 'unable_to_attend'
    if @invitation.get('status') != new_status
      @confirm(new_status)

  resetStatus: =>
    new_status = 'unconfirmed'
    if @invitation.get('status') != new_status
      @confirm(new_status)
    @$('.btn-attending').removeClass('active')
    @$('.btn-not-attending').removeClass('active')

  confirm: (new_status) =>
    @invitation.confirm(
      new_status,
      wait: true
      success: (guest, xhr, status) =>
        console.log "Confirmation is successful!"
        @invitation.set("status": new_status)
        @invitation.trigger("statusConfirmed", {'new_status': new_status})
      error: (jqXHR) =>
        console.log "Error: #{jqXHR}"
    )

  addEditGuests: (options) =>
    egview = new WeddingPrototype.Views.Invitations.EditGuestsView(invitation: @invitation)
    @$('.edit-guests').html(egview.render().el)

  removeEditGuests: (options) =>
    @$('.edit-guests').html("")

  setActiveButton: =>
    if @invitation.get('status') == 'attending'
      @$('.btn-attending').addClass('active')
    else if @invitation.get('status') == 'unable_to_attend'
      @$('.btn-not-attending').addClass('active')

  render: =>
    @$el.html(@template())
    @$(".reset-status").css("cursor", "pointer")
    @$(".reset-status").tooltip(placement: "bottom")
    @setActiveButton()
    return this
