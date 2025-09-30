module ApplicationHelper
  def admin_user?
    authenticated? && Rails.application.config.admin_user_ids.include?(Current.user.id)
  end
end
