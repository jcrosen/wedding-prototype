WeddingPrototype.Views.Invitations ||= {}

class WeddingPrototype.Views.Invitations.IndexView extends Backbone.View
  template: JST["backbone/templates/invitations/index"]

  events:
    'click #attendance-progress-bar-close': 'closeProgressBarPopover'
    'click #attendance-incomplete-bar-close': 'closeIncompleteBarPopover'

  initialize: (options) ->
    @invitations = options.collection
    @invitations.bind('reset', @addAll)
    @columns_per_invitation = options.columns_per_invitation or 6
    @offset = options.offset or 0
    @achievements = options.achievements

  addAll: () =>
    invitations_per_row = Math.floor(12 / @columns_per_invitation)
    row_id = 0
    for invitation, index in @invitations.models
      if index % invitations_per_row == 0
        row_id += 1
        @addRow(@rowIdCss(row_id))
      @addOne(@rowIdCss(row_id), invitation)

  rowIdCss: (id) ->
    return "invitations-row-#{id}"

  addRow: (row_id) =>
    @$("#invitations-index-container").append("<div id='#{row_id}' class='invitations-row row-fluid'></div>")

  addGuestsModal: =>
    @guestsModalView = new WeddingPrototype.Views.Guests.ModalIndexView()
    $('body').append(@guestsModalView.render().el)

  addOne: (row_id, invitation) =>
    iview = new WeddingPrototype.Views.Invitations.ShowView(
      model: invitation,
      collection: @invitations,
      columns: @columns_per_invitation,
      offset: @offset,
      guestsModalView: @guestsModalView
    )
    @$("##{row_id}").append(iview.render().el)

  closeProgressBarPopover: ->
    @$("#attendance-progress-bar").popover('hide')

  closeIncompleteBarPopover: ->
    @$("#attendance-incomplete-bar").popover('hide')

  closePopoverButtonHtml: (css_id) ->
    return "<button type='button' id='#{css_id}-close' class='close light-padding' >&times;</button>"

  render: =>
    @$el.html(
      @template(
        status_complete_percent: @achievements.invitation_status_percent_complete,
        completed_tasks_html: @achievements.invitation_completed_tasks_html,
        remaining_tasks_html: @achievements.invitation_remaining_tasks_html
      )
    )
    @addGuestsModal()
    @addAll()
    @$('#attendance-progress-bar').popover(html: 'true', title: "#{@closePopoverButtonHtml('attendance-progress-bar')} Completed Tasks")
    @$('#attendance-incomplete-bar').popover(html: 'true', title: "#{@closePopoverButtonHtml('attendance-incomplete-bar')} Remaining Tasks")
    @$('#attendance-progress-bar').css("cursor", "pointer")
    @$('#attendance-incomplete-bar').css("cursor", "pointer")
    return this
