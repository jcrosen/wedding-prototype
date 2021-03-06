module PagesHelper
  
  # simple helper that renders the event panel partials based on the 
  def render_event_panels(events)
    total_columns = 12
    events_per_row = 3
    columns_per_event = total_columns / events_per_row
    counter = 0
    r = "".html_safe
    
    while counter < events.size
      r += render partial: "pages/event_row", locals: { number_of_columns: columns_per_event, events: events[counter..(counter+(events_per_row-1))] }
      counter += events_per_row
    end
    
    r
  end
  
  def render_posts(posts)
    render partial: "posts/post", collection: posts, as: :post
  end
  
end
