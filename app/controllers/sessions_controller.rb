class SessionsController < ApplicationController
  allow_unauthenticated_access only: %i[ new create omniauth omniauth_failure ]
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_session_path, alert: "Try again later." }

  def new
  end

  def create
    if user = User.authenticate_by(params.permit(:email_address, :password))
      start_new_session_for user, remember_me: ActiveModel::Type::Boolean.new.cast(params[:remember_me])
      redirect_to after_authentication_url
    else
      redirect_to new_session_path, alert: "Try another email address or password."
    end
  end

  def destroy
    terminate_session
    redirect_to new_session_path, status: :see_other
  end

  def omniauth
    user = User.from_google_oauth!(request.env["omniauth.auth"])
    start_new_session_for user, remember_me: true
    redirect_to after_authentication_url, notice: "Signed in with Google."
  rescue StandardError
    redirect_to new_session_path, alert: "Google sign in failed."
  end

  def omniauth_failure
    redirect_to new_session_path, alert: "Google sign in failed."
  end
end
