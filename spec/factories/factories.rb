# Miniskirt factory definitions
require 'miniskirt'

Factory.define :user, class: User do |u|
  u.display_name "user %d"
  u.email "user%d@wedding.com"
  u.password u.password_confirmation('please')
end

Factory.define :event, class: Event do |e|
  e.title "Event Title %d"
  e.description "%{title} Description - Longer than the title"
  e.scheduled_date { Time.new }
  e.location "1234 Anywhere St, Portland, OR"
end

Factory.define :invitation, class: Invitation do |i|
  i.status { rand() > 0.5 ? (rand() > 0.3 ? "attending" : "unable_to_attend") : "unconfirmed" }
  i.event_id { Factory.create(:event).id }
  i.sent_date { Time.new }
  i.confirmed_date { |inv| inv.status ? Time.new : nil }
  i.max_party_size "#{1 + (rand() * 8)}"
end

Factory.define :invitation_user, class: InvitationUser do |iu|
  iu.role { Invitation.all.size == 0 ? "owner" : "viewer" }
  iu.user_id { Factory.create(:user).id }
  iu.invitation_id { Factory.create(:invitation).id }
end

Factory.define :post, class: Post do |p|
  p.title { "Post Title %d" }
  p.raw_body { "##### I'm a raw markdown content body
                Isn't this fun?!
                
                * weeee
                * wooooo
                
                # wooooot
                # weeeeet
    " }
  p.user_id { Factory.create(:user) }
end
