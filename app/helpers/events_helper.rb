module EventsHelper
  
  def render_event_map(event)
    return '<iframe width="425" height="350" frameborder="0" scrolling="no" marginheight="0" marginwidth="0" src="https://maps.google.com/maps?f=q&amp;source=s_q&amp;hl=en&amp;geocode=&amp;q=1900+NW+18th+Ave,+Portland,+OR,+97209&amp;aq=&amp;sll=45.536693,-122.689302&amp;sspn=0.001658,0.003144&amp;t=h&amp;ie=UTF8&amp;hq=&amp;hnear=1900+NW+18th+Ave,+Portland,+Multnomah,+Oregon+97209&amp;ll=45.542908,-122.688446&amp;spn=0.02104,0.036478&amp;z=14&amp;iwloc=A&amp;output=embed"></iframe><br /><small><a href="https://maps.google.com/maps?f=q&amp;source=embed&amp;hl=en&amp;geocode=&amp;q=1900+NW+18th+Ave,+Portland,+OR,+97209&amp;aq=&amp;sll=45.536693,-122.689302&amp;sspn=0.001658,0.003144&amp;t=h&amp;ie=UTF8&amp;hq=&amp;hnear=1900+NW+18th+Ave,+Portland,+Multnomah,+Oregon+97209&amp;ll=45.542908,-122.688446&amp;spn=0.02104,0.036478&amp;z=14&amp;iwloc=A" style="color:#0000FF;text-align:left">View Larger Map</a></small>'.html_safe
  end
  
end
