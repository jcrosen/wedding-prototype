WeddingPrototype.Views.Invitations ||= {}

class WeddingPrototype.Views.Invitations.ShowView extends Backbone.View
  template: JST["backbone/templates/invitations/show"]

  events:
    'click #close-confirm-alert': 'hideConfirmAlert'

  initialize: (options) ->
    @invitation = options.model
    @collection = options.collection
    @columns = options.columns or 12
    @offset = options.offset or 0
    @guestsModalView = options.guestsModalView
    @invitation.bind('statusConfirmed', @resetStatus)
    @invitation.bind('editGuests', @editGuests)
    @activeClass = 'invitation-attending'
    @disabledClass = 'invitation-not-attending'
    @unconfirmedClass = 'invitation-unconfirmed'

  hideConfirmAlert: =>
    @$('.confirm-alert').hide()

  clearStatus: =>
    @$('.invitation-unit').removeClass(@activeClass)
    @$('.invitation-unit').removeClass(@disabledClass)
    @$('.invitation-unit').removeClass(@unconfirmedClass)
    @hideConfirmAlert()

  resetStatus: (args) =>
    args ||= {}
    new_status = args['new_status']

    if not new_status?
      new_status = @invitation.get('status')

    @clearStatus()

    if new_status == 'attending'
      @$('.invitation-unit').addClass(@activeClass)
      @addEditGuests()
    else
      @removeEditGuests()
      if new_status == 'unable_to_attend'
        @$('.invitation-unit').addClass(@disabledClass)
      else if new_status == 'unconfirmed'
        @$('.invitation-unit').addClass(@unconfirmedClass)
        @$('.confirm-alert').show()

  addConfirmation: =>
    @confirmationView = new WeddingPrototype.Views.Invitations.ConfirmationView(invitation: @invitation)
    @$(".invitation-status-confirmation").html(@confirmationView.render().el)

  addEditGuests: =>
    @confirmationView.addEditGuests(invitation: @invitation)

  removeEditGuests: =>
    @confirmationView.removeEditGuests()

  addGuestsModal: =>
    cssId = "invitation-#{@invitation.id}-guests-modal"
    @guestsModalView = new WeddingPrototype.Views.Guests.ModalIndexView(invitation: @invitation, cssId: cssId)
    $('body').append(@guestsModalView.render().el)

  editGuests: =>
    @guestsModalView.prepare(invitation: @invitation)
    @guestsModalView.modal()

  render: () =>
    @$el.html(@template(invitation: @invitation, event: @invitation.get('event'), columns: @columns))
    @$el.addClass("span#{@columns}")
    if @offset > 0
      @$el.addClass("offset#{@offset}")

    # If we haven't received a guests modal id yet then render a guests modal once. This is so an
    # invitations index can pass in the proper guests modal and we don't create more than we need
    if not @guestsModalView
      @addGuestsModal()

    @addConfirmation()
    @resetStatus()
    return this