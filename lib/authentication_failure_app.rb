# frozen_string_literal: true

require 'sso_helpers'

class AuthenticationFailureApp < Devise::FailureApp
  include SSOHelpers

  def route(scope)
    if sso_enabled?
      :user_doorkeeper_omniauth_authorize_url
    else
      :login_url
    end
  end
end