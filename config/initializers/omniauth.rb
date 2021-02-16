# frozen_string_literal: true

require "omniauth/strategies/doorkeeper"

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :doorkeeper, scope: "read profile", strategy_class: OmniAuth::Strategies::Doorkeeper
end