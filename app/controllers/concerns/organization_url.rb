# frozen_string_literal: true

module OrganizationUrl
  extend ::ActiveSupport::Concern

  def root_url_with_subdomain(organization)
    subdomain = if ENV["HEROKU_APP_NAME"].present?
      ENV["HEROKU_APP_NAME"]
    elsif !organization && request_subdomain == "www"
      "www"
    else
      organization.subdomain
    end

    url = url_for(host: request.base_url, subdomain: subdomain, port: request.port)
    URI.join(url, "/").to_s
  end

  def request_subdomain
    if ENV["HEROKU_APP_NAME"].present?
      "spinkart"
    else
      request.subdomain
    end
  end
end
