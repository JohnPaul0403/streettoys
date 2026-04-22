module ApplicationHelper
  def profile_name_for(user)
    user.profile&.username.presence || user.email_address.split("@").first
  end

  def profile_title_for(user)
    user.profile&.title.presence || "Street rider"
  end

  def google_oauth_enabled?
    return false unless ENV["GOOGLE_CLIENT_ID"].present? && ENV["GOOGLE_CLIENT_SECRET"].present?

    OmniAuth.strategies.any? { |strategy| strategy.to_s == "OmniAuth::Strategies::GoogleOauth2" }
  end
end
