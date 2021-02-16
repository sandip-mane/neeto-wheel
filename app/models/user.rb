# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise  :database_authenticatable,
          :registerable,
          :recoverable,
          :trackable,
          :rememberable

  before_save :ensure_authentication_token_is_present

  validates :first_name, :last_name, presence: true

  validates_uniqueness_of :email, allow_blank: true, case_sensitive: false, scope: :organization_id

  belongs_to :organization

  has_many :notes, dependent: :delete_all

  def name
    [first_name, last_name].join(" ").strip
  end

  def as_json(options = {})
    new_options = options.merge(only: [:email, :first_name, :last_name, :current_sign_in_at])

    super new_options
  end

  def self.current
    Thread.current[:user]
  end

  def self.current=(user)
    Thread.current[:user] = user
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
