class AddCreatorToOrganizations < ActiveRecord::Migration[6.0]
  def change
    add_column :organizations, :creator_id, :uuid
    add_foreign_key :organizations, :users, column: :creator_id
  end
end
