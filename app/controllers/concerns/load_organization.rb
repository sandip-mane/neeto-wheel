# frozen_string_literal: true

module LoadOrganization
  extend ActiveSupport::Concern

  included do
    before_action :load_organization
  end

  def load_organization
    if request_subdomain.present?
      @organization = Organization.find_by(subdomain: request_subdomain)
      set_current_organization if @organization.present?
    else
      # ideally redirections must be handled from web server
      redirect_to(www_subdomain_url) and return
    end
  end

  private

    def set_current_organization
      Organization.current = @organization
      session[:organization_id] = @organization.id
    end

    def www_subdomain?
      request_subdomain.present? && request_subdomain == "www"
    end

    def www_subdomain_url
      if request.subdomain.present?
        request.url.sub(/\/\/[^.]+/, "//www")
      else
        request.url.sub(/\/\//, "//www.")
      end
    end

    def request_subdomain
      if app_secrets.heroku_app_name.present?
        app_secrets.default_subdomain
      else
        request.subdomain
      end
    end
end