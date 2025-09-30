class ApplicationController < ActionController::Base
  include Authentication
  include ApplicationHelper

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  private

  def track_action
    ahoy.track "Action", request.path_parameters
  end

  def require_admin
    unless admin_user?
      render plain: "Access denied - Admin privileges required", status: 403
    end
  end
end
