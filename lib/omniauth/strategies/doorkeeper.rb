# frozen_string_literal: true

module OmniAuth
  module Strategies
    class Doorkeeper < OmniAuth::Strategies::OAuth2
      def client
        client_id     = organization&.auth_app_id
        client_secret = organization&.auth_app_secret
        site          = organization&.auth_app_url

        ::OAuth2::Client.new(
          client_id, client_secret,
          deep_symbolize(options.client_options.merge(site: site))
        )
      end

      option :name, :doorkeeper

      option :client_options, authorize_path: '/oauth/authorize'

      option :authorize_params, { chain: 'no' }

      def setup_phase
        request.env['omniauth.strategy'].options[:authorize_params][:chain] = session[:chain_authentication] || 'no'
      end

      uid do
        raw_info['id']
      end

      info do
        {
          email:        raw_info['email'],
          first_name:   raw_info['first_name'],
          last_name:    raw_info['last_name'],
          image:        raw_info['image'],
          date_format:  raw_info['date_format'],
          time_zone:    raw_info['time_zone']
        }
      end

      def raw_info
        @_raw_info ||= access_token.get('/api/v1/me.json').parsed
      end

      def organization
        organization_id = session[:organization_id]

        @organization ||= if organization_id.present?
          Organization.find_by_id(organization_id)
        else
          env_server_name = env['SERVER_NAME'].to_s
          subdomain = env_server_name.split('.').first

          if subdomain.present?
            organization = Organization.find_by(subdomain: subdomain)
            return organization if organization
          end

          Organization.find_by(subdomain: Rails.application.secrets.app_subdomain)
        end
      end
    end
  end
end