# frozen_string_literal: true

class Api::V1::Server::BaseController < ActionController::Base
  skip_before_action :verify_authenticity_token

  before_action :verify_http_authenticity_token

  private

    def verify_http_authenticity_token
      authorization_token = Rails.application.secrets.server_authorization_token

      authenticate_or_request_with_http_token do |token, options|
        ActiveSupport::SecurityUtils.secure_compare(token, authorization_token)
      end
    end
end