# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :set_honeybadger_context

  private

    def set_honeybadger_context
      hash = { uuid: request.uuid }
      hash.merge!(user_id: current_user.id, user_email: current_user.email) if current_user
      Honeybadger.context hash
    end
end
