WeddingPrototype.Views.Invitations ||= {}

class WeddingPrototype.Views.Invitations.ProgressBarView extends Backbone.View
  template: JST["backbone/templates/invitations/progress_bar"]

  events:
    'click #completed-progress-bar-close': 'closeCompletedProgressPopover'
    'click #pending-progress-bar-close': 'closePendingProgressPopover'

  initialize: (options) ->
    @invitations = options.invitations
    @invitations.bind('updateProgress', @updateProgress)

  completedItems: =>
    totalCount = @invitations.length * 2 #Assume each invitation has 2 actions, it's status and it's guest list
    completedVm =
      percent: '0%'
      tasks: []
    completedCount = 0

    for invitation in @invitations.models
      if invitation.isConfirmed()
        taskString = "RSVP for #{invitation.get('event').title}"
        iCompleteCount = 1
        if invitation.get('guests').length > 1
          taskString += " and updated the guest list"
          iCompleteCount += 1
        completedVm.tasks.push(
          taskString + " - " + Math.round((iCompleteCount / totalCount) * 100).toString() + "%"
        )
        completedCount += iCompleteCount

    completedVm.percent = Math.round((completedCount / totalCount) * 100).toString() + "%"
    console.log completedVm

    return completedVm

  # TODO: combine this with completedItems to consolidate code and prevent overlapping conditions
  pendingItems: =>
    totalCount = @invitations.length * 2 #Assume each invitation has 2 actions, it's status and it's guest list
    pendingVm =
      percent: '0%'
      tasks: []
    pendingCount = 0

    for invitation in @invitations.models
      iPendingCount = 0
      taskString = ""
      if not invitation.isConfirmed()
        taskString = "RSVP for #{invitation.get('event').title} and update the guest list"
        iPendingCount = 2
      else if invitation.get('guests').length == 1
        iPendingCount = 1
        taskString = "Update the guest list for #{invitation.get('event').title}"
      if iPendingCount > 0
        pendingVm.tasks.push( taskString + " - " + Math.round((iPendingCount / totalCount) * 100).toString() + "%" )
        pendingCount += iPendingCount

    pendingVm.percent = Math.round((pendingCount / totalCount) * 100).toString() + "%"
    console.log pendingVm

    return pendingVm

  updateProgress: =>
    @$('#completed-progress-bar').popover('destroy')
    @$('#pending-progress-bar').popover('destroy')
    
    completed = @completedItems()
    pending = @pendingItems()

    completedBar = @$('#completed-progress-bar')
    pendingBar = @$('#pending-progress-bar')

    completedBar.width(completed.percent)
    pendingBar.width(pending.percent)

    @$('#completed-progress-bar').popover(
      html: 'true', 
      placement: 'bottom', 
      title: "#{@closePopoverButtonHtml('completed-progress-bar')} Completed Tasks",
      content: "<ul><li>" + completed.tasks.join("</li><li>") + "</li></ul>"
    )
    @$('#pending-progress-bar').popover(
      html: 'true', 
      placement: 'bottom', 
      title: "#{@closePopoverButtonHtml('pending-progress-bar')} Remaining Tasks",
      content: "<ul><li>" + pending.tasks.join("</li><li>") + "</li></ul>"
    )

  closeCompletedProgressPopover: ->
    @$("#completed-progress-bar").popover('hide')

  closePendingProgressPopover: ->
    @$("#pending-progress-bar").popover('hide')

  closePopoverButtonHtml: (css_id) ->
    return "<button type='button' id='#{css_id}-close' class='close light-padding' >&times;</button>"

  render: =>
    @$el.html(@template())
    @updateProgress()
    @$('#completed-progress-bar').css("cursor", "pointer")
    @$('#pending-progress-bar').css("cursor", "pointer")

    return @