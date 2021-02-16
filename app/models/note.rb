# frozen_string_literal: true

class Note < ApplicationRecord
  belongs_to :user
  belongs_to :organization

  validates :title, :description, presence: true
  validates :title, uniqueness: true
end
