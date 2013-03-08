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
    @invitation.bind('statusConfirmed', @resetStatus)
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
    else if new_status == 'unable_to_attend'
      @$('.invitation-unit').addClass(@disabledClass)
    else if new_status == 'unconfirmed'
      @$('.invitation-unit').addClass(@unconfirmedClass)
      @$('.confirm-alert').show()

  addConfirmation: =>
    cview = new WeddingPrototype.Views.Invitations.ConfirmationView(invitation: @invitation)
    @$(".invitation-status-confirmation").html(cview.render().el)

  render: () =>
    @$el.html(@template(invitation: @invitation, event: @invitation.get('event'), columns: @columns))
    @$el.addClass("span#{@columns}")
    if @offset > 0
      @$el.addClass("offset#{@offset}")
    @addConfirmation()
    @resetStatus()
    return this