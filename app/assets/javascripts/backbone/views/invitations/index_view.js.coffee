WeddingPrototype.Views.Invitations ||= {}

class WeddingPrototype.Views.Invitations.IndexView extends Backbone.View
  template: JST["backbone/templates/invitations/index"]

  initialize: (options) ->
    @invitations = options.collection
    @invitations.bind('reset', @addAll)
    @invitations.bind('reset', @renderProgressBar)
    @columns_per_invitation = options.columns_per_invitation or 6
    @offset = options.offset or 0

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

  renderProgressBar: =>
    @progressBarView = new WeddingPrototype.Views.Invitations.ProgressBarView(invitations: @invitations)
    @$('#invitations-progress-bar').html( @progressBarView.render().el )

  addOne: (row_id, invitation) =>
    iview = new WeddingPrototype.Views.Invitations.ShowView(
      model: invitation,
      collection: @invitations,
      columns: @columns_per_invitation,
      offset: @offset,
      guestsModalView: @guestsModalView
    )
    @$("##{row_id}").append(iview.render().el)

  render: =>
    @$el.html( @template() )
    @addGuestsModal()
    @addAll()
    return this
