# frozen_string_literal: true

module SSOHelpers
  def sso_enabled?
    return false if Rails.env.heroku?

    Rails.application.secrets.sso_enabled
  end

  def app_secrets
    @_app_secrets ||= Rails.application.secrets
  end
end