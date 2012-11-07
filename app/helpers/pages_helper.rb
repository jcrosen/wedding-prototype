module PagesHelper
  
  # simple helper that renders the event panel partials based on the 
  def render_event_panels(events)
    events_per_row = 1
    columns_per_event = "twelve"
    counter = 0
    r = "".html_safe
    
    while counter < events.size
      r += render partial: "pages/event_row", locals: { number_of_columns: columns_per_event, events: events[counter..(counter+(events_per_row-1))] }
      counter += events_per_row
    end
    
    r
  end
  
end
