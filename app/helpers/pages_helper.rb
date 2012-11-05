module PagesHelper
  
  def render_event_panels(events)
    events_per_row = 3
    columns_per_event = "four"
    counter = 0
    r = "".html_safe
    
    while counter < events.size
      r += render partial: "pages/event_row", locals: { columns_per_event: columns_per_event, events: events[counter..(counter+(events_per_row-1))] }
      counter += events_per_row
    end
    
    r
    
  end
  
end
