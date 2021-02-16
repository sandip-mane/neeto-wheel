# frozen_string_literal: true

class Organization < ApplicationRecord
  SUBDOMAIN_FORMAT_REGEX = /\A[a-z0-9\-\_]+\z/.freeze
  PLATFORM_SUBDOMAINS = %w[app www].freeze


  validates :name, :subdomain, presence: true
  validates :subdomain, presence: true,
                        length: { minimum: 2 },
                        uniqueness: { case_sensitive: false, allow_nil: false },
                        format: {
                          with: SUBDOMAIN_FORMAT_REGEX,
                          message: 'accepts lowercase alphanumeric or special character underscore(_) and hyphen(-)'
                        }

  belongs_to :creator, class_name: "User", optional: true
  belongs_to :deleted_by, class_name: "User", optional: true

  has_many :users, dependent: :destroy
  has_many :notes, dependent: :destroy

  def self.current
    Thread.current[:organization]
  end

  def self.current=(organization)
    Thread.current[:organization] = organization
  end
end
