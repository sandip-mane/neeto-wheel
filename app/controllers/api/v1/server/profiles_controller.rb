# frozen_string_literal: true

class Api::V1::Server::ProfilesController < Api::V1::Server::BaseController
  before_action :set_organization

  def update
    @user = User.find_by(email: profile_params[:email], organization_id: @organization.id)

    if @user
      if @user.update(profile_params.except(:email))
        render json: { success: true }
      else
        render json: { success: false, error: @user.errors.full_messages.to_sentence }, status: :unprocessable_entity
      end
    else
      render json: { success: false, error: t('resource.not_found', resource_name: 'User') }, status: :not_found
    end
  end

  private

    def profile_params
      @_profile_params ||= params.require(:profile).permit(
        :email,
        :first_name,
        :last_name,
        :profile_image_url,
        :time_zone,
        :date_format
      )
    end

    def set_organization
      @organization = Organization.find_by(subdomain: params[:subdomain])
    end
end