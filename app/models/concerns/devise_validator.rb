# frozen_string_literal: true

module DeviseValidator
  extend ActiveSupport::Concern

  VALID_EMAIL_REGEX = /\b[A-Z0-9._%a-z\-]+@(?:[A-Z0-9a-z\-]+\.)+[A-Za-z]{2,4}\z/

  included do
    validates :email, presence: true
    validates :email, uniqueness: { allow_blank: true, scope: :organization_id, if: :email_changed? }
    validates :email, format: { with: VALID_EMAIL_REGEX, allow_blank: true, if: :email_changed? }
    validates :password, presence: true, on: :create
  end
end