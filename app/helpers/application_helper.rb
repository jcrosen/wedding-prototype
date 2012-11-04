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
  
end
