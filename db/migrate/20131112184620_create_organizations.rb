class CreateOrganizations < ActiveRecord::Migration[6.0]
  def change
    create_table :organizations, id: :uuid do |t|
      t.string    :name
      t.string    :api_key
      t.string    :subdomain
      t.boolean   :google_login_enabled,  default: false
      t.uuid      :deleted_by_id
      t.datetime  :deleted_at

      t.timestamps

      # SSO attributes
      t.string :auth_app_url
      t.string :auth_app_id
      t.string :auth_app_secret
    end

    add_index :organizations, :deleted_at
    add_index :organizations, :subdomain
  end
end
