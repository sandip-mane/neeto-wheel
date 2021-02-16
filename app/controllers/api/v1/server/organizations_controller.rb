# frozen_string_literal: true

class Api::V1::Server::OrganizationsController < Api::V1::Server::BaseController
  def create
    @organization = Organization.find_or_initialize_by(organization_params.slice(:name, :subdomain))
    if @organization.update(organization_params.except(:name, :subdomain))
      render json: { success: true }
    else
      render json: { success: false, error: @organization.errors.full_messages.to_sentence }, status: :unprocessable_entity
    end
  end

  private

    def organization_params
      @_organization_params ||= params.require(:organization).permit(
        :name,
        :subdomain,
        :auth_app_url,
        :auth_app_id,
        :auth_app_secret,
      )
    end
end