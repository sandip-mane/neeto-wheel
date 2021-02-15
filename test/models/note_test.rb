# frozen_string_literal: true

require "test_helper"

class NoteTest < ActiveSupport::TestCase
  def setup
    @admin = create :user, :admin
  end

  def test_valid_note
    note = create :note, description: "oliver@example.com", title: "Oliver Smith", user: @admin
    assert note.valid?
  end

  def test_invalid_note
    note = build :note, description: "", title: "", user: @admin

    assert_not note.valid?
    assert_includes note.errors.full_messages, "Title can't be blank"
    assert_includes note.errors.full_messages, "Description can't be blank"
  end
end
