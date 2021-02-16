# frozen_string_literal: true

class Organization < ApplicationRecord
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
