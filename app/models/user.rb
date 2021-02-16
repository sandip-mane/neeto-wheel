# frozen_string_literal: true

class User < ApplicationRecord
  include DeviseValidator

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise  :database_authenticatable,
          :registerable,
          :recoverable,
          :trackable,
          :rememberable,
          :omniauthable,
          omniauth_providers: %i[doorkeeper]

  before_save :ensure_authentication_token_is_present

  validates :first_name, :last_name, presence: true

  validates_uniqueness_of :email, allow_blank: true, case_sensitive: false, scope: :organization_id

  belongs_to :organization

  has_many :notes, dependent: :delete_all

  def as_json(options = {})
    new_options = options.merge(only: [:email, :first_name, :last_name, :current_sign_in_at])

    super new_options
  end

  # SSO
  def name
    [first_name, last_name].join(" ").strip
  end

  def display_name
    name || email
  end

  def self.current
    Thread.current[:user]
  end

  def self.current=(user)
    Thread.current[:user] = user
  end

  class << self
    def from_omniauth(auth)
      where(email: auth.info.email, organization_id: Organization.current.id).first_or_create! do |user|
        user.first_name = auth.info.first_name
        user.last_name = auth.info.last_name
        user.password = default_password
        user.provider = auth.provider
        user.uid =  auth.uid
        user.profile_image_url = auth.info.image
      end
    end

    def default_password
      if Rails.env.development? || Rails.env.heroku?
        Rails.application.secrets.default_password
      else
        Devise.friendly_token.first(12)
      end
    end
  end

  def update_name_and_doorkeeper_credentials(auth)
    update(
      doorkeeper_access_token: auth.credentials.token,
      doorkeeper_refresh_token: auth.credentials.refresh_token,
      doorkeeper_token_expires_at: auth.credentials.expires_at,
      first_name: auth.info.first_name,
      last_name: auth.info.last_name
    )
  end

  private

    def send_devise_notification(notification, *args)
      devise_mailer.send(notification, self, *args).deliver_later(queue: "devise_email")
    end

    def ensure_authentication_token_is_present
      if authentication_token.blank?
        self.authentication_token = generate_authentication_token
      end
    end

    def generate_authentication_token
      loop do
        token = Devise.friendly_token
        break token unless User.where(authentication_token: token).first
      end
    end
end
