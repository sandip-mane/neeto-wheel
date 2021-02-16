# frozen_string_literal: true

module LoadOrganization
  extend ActiveSupport::Concern
  include OrganizationUrl

  included do
    before_action :load_organization
  end

  def load_organization
    if request_subdomain.present?
      @organization = find_organization_by_subdomain
      set_current_organization if @organization.present?
    else
      # ideally redirections must be handled from web server
      redirect_to_www and return
    end

    redirect_to_www if need_redirection_to_www?
    @sign_in_configs = @organization && sign_in_configs
  end

  private

    def redirect_to_www
      redirect_to(www_subdomain_url) and return
    end

    def redirect_to_auth_server
      app_secrets = Rails.application.secrets
      auth_subdomain_url = app_secrets.auth_app[:url].gsub(app_secrets.app_subdomain, request.subdomain)
      redirect_to(auth_subdomain_url) and return
    end

    def need_redirection_to_auth_server?
      @organization.blank? && !www_subdomain?
    end

    def need_redirection_to_www?
      @organization.blank? && request_subdomain != "www"
    end

    def set_current_organization
      Organization.current = @organization
      session[:organization_id] = @organization.id
    end

    def find_organization_by_subdomain
      Rails.cache.fetch("organizations/subdomains/#{request_subdomain}", expires_in: 12.hours) do
        Organization.find_by(subdomain: request_subdomain)
      end
    end

    def www_subdomain?
      request_subdomain.present? && request_subdomain == 'www'
    end

    def www_subdomain_url
      if request.subdomain.present?
        request.url.sub(/\/\/[^.]+/, '//www')
      else
        request.url.sub(/\/\//, '//www.')
      end
    end

    def sign_in_configs
      {
        google_signin_enabled: @organization.google_login_enabled
      }
    end
end
