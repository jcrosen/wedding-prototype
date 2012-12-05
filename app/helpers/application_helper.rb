module ApplicationHelper
  
  def include_files
    render partial: "shared/includes"
  end
  
  def render_top_bar
    render partial: "shared/top_bar"
  end
  
  def render_top_nav
    render partial: "shared/top_nav"
  end
  
  def render_alert_boxes
    render partial: "shared/alert_boxes"
  end
  
  def render_sign_in_modal
    render partial: "shared/sign_in_modal"
  end
  
  #TODO: the event and post listings do not conform to the standard controller resource retrieval model; the authorization and access control are implicit here
  def render_top_nav_events
    render partial: "shared/top_nav_event_listing", collection: user_events, as: :event
  end
  
  def render_top_nav_posts
    render partial: "shared/top_nav_post_listing", collection: user_posts, as: :post
  end
  
  def user_events
    Event.with_user(current_user)
  end
  
  def user_posts
    Post.with_viewer(user: current_user)
  end
  
  def markdown(text)
    @markdown ||= Redcarpet::Markdown.new(Redcarpet::Render::HTML, :autolink => true, :space_after_headers => true)
    
    @markdown.render(text).html_safe
  end
  
end
