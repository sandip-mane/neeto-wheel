# frozen_string_literal: true

class HomeController < ApplicationController
  before_action :redirect_to_auth_server, only: [:index], if: :need_redirection_to_auth_server?
  before_action :authenticate_user!, only: [:index], if: :need_authentication?
  layout :layout_by_subdomain

  def index
    www_subdomain? ? render(website_page) : render
  end

  private
    def redirect_to_auth_server
      auth_subdomain_url = app_secrets.auth_app[:url].gsub(app_secrets.app_subdomain, request.subdomain)
      redirect_to(auth_subdomain_url) and return
    end

    def need_authentication?
      @organization.present? && !www_subdomain?
    end

    def need_redirection_to_auth_server?
      @organization.blank? && !www_subdomain?
    end

    def layout_by_subdomain
      www_subdomain? ? 'website' : 'application'
    end

    def website_page
      params[:path] ? "pages/#{params[:path]}" : 'pages/index'
    end
end
