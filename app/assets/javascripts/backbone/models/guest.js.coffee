class WeddingPrototype.Models.Guest extends Backbone.Model
  paramRoot: 'guest'

  defaults:
    invitation_id: null
    role: null
    user_id: null
    first_name: null
    last_name: null
    display_name: null

  parse: (response) ->
    if response.guest
      #console.log "Parsing the Guest model response with an embedded guest node from the server: #{response}"
      return response.guest
    else
      #console.log "Parsing the Guest model response without an embedded guest node from the collection"
      return response

class WeddingPrototype.Collections.Guests extends Backbone.Collection
  initialize: (options) ->
    @invitation = options.invitation
    @invitation_id = @invitation.id
    @fetch()
    @bind("add", @guestsChanged)
    @bind("remove", @guestsChanged)
    @bind("reset", @guestsChanged)

  model: WeddingPrototype.Models.Guest
  url: ->
    "/invitations/#{@invitation_id}/guests"

  guestsChanged: () =>
    @invitation.trigger("guestsChanged", @)

  # overriding the guest parsing to strip the guests as an individual JS node in the response
  parse: (response) ->
    if response.guests
      #console.log "I'm getting 'guests' in the response: #{response})"
      return response.guests
    else
      #console.log "I'm not getting 'guests' in the response: #{response})"
      return response