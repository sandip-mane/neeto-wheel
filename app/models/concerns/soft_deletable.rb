# frozen_string_literal: true

module SoftDeletable
  extend ActiveSupport::Concern

  included do
    default_scope { where(deleted_at: nil) }
    scope :deleted, -> { unscope(where: :deleted_at).where.not(deleted_at: nil) }
  end

  def destroy
    update_columns(deleted_at: DateTime.now, deleted_by: User.current)
  end

  def really_destroy
    update_columns(deleted_at: DateTime.now, deleted_by: User.current)
  end
end
