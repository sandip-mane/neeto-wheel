# frozen_string_literal: true

require "test_helper"

class UserTest < ActiveSupport::TestCase
  def test_first_name_is_blank
    user = build :user, :admin, first_name: nil, last_name: "Smith"
    assert_equal "Smith", user.name
  end

  def test_last_name_is_blank
    user = build :user, :admin, first_name: "Adam", last_name: nil
    assert_equal "Adam", user.name
  end

  def test_as_json
    user = create :user, :admin, first_name: "Adam", last_name: "Smith", email: "admin@example.com"

    expected = { "email" => "admin@example.com", "current_sign_in_at" => nil, "last_name" => "Smith", "first_name" => "Adam" }
    assert_equal expected, user.as_json
  end
end
