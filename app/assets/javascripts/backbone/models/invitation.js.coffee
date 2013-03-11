class WeddingPrototype.Models.Invitation extends Backbone.Model
  paramRoot: 'invitation'
  url: "/invitations"

  defaults:
    event_id: null
    status: null
    sent_at: null
    confirmed_at: null
    max_party_size: null
    status_hash: null
    printable_status: null
    event: null
    guests: null

  parse: (response) ->
    if response.invitation
      return response.invitation
    else
      return response

  initialize: (options) ->
    @options = options

  confirm: (status, options) ->
    response = (@sync || Backbone.sync).call @, 'confirm', @,
      url: "#{@url}/#{@id}/confirm"
      data: "status=#{status}"
      type: "PUT"
      success: options.success
      error: options.error
      wait: options.wait

class WeddingPrototype.Collections.Invitations extends Backbone.Collection
  model: WeddingPrototype.Models.Invitation
  url: '/invitations'

  parse: (response) ->
    if response.invitations
      return response.invitations
    else
      return response
    
