# frozen_string_literal: true

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def doorkeeper
    user = User.from_omniauth(request.env["omniauth.auth"])

    if user.persisted?
      user.update_name_and_doorkeeper_credentials(request.env["omniauth.auth"])
      session[:doorkeeper_user_id] = user.id
      sign_in_and_redirect(user, event: :authentication)
    else
      session["devise.doorkeeper_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end

  def failure
    redirect_to root_path
  end
end