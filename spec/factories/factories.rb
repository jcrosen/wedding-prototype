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
  i.status { rand() > 0.5 ? (rand() > 0.5 ? "Attending" : "Not Attending") : "Not Confirmed" }
  i.event_id { Factory.create(:event).id }
  i.user_id { Factory.create(:user).id }
  i.sent_date { Time.new }
  i.confirmed_date { |inv| inv.status ? Time.new : nil }
  i.party_size "#{rand() * 10}"
end
