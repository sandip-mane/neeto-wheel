# frozen_string_literal: true

class AddDeviseToUsers < ActiveRecord::Migration[6.0]
  def self.up
    create_table :users, id: :uuid do |t|
      ## Database authenticatable
      t.string :email,              null: false, default: ""
      t.string :encrypted_password, null: false, default: ""

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      t.integer  :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip

      t.timestamps

      # Custom attributes
      t.string      :first_name
      t.string      :last_name
      t.string      :role, default: "standard"
      t.string      :authentication_token
      t.datetime    :last_invitation_sent_at
      t.references  :organization, null: false, type: :uuid, foreign_key: true

      # SSO attributes
      t.string  :time_zone, default: 'UTC'
      t.string  :provider
      t.string  :uid
      t.string  :doorkeeper_access_token
      t.string  :doorkeeper_refresh_token
      t.integer :doorkeeper_token_expires_at
      t.string  :profile_image_url
      t.string  :date_format
    end

    add_index :users, %i[email organization_id], unique: true
    add_index :users, :reset_password_token, unique: true
    # add_index :users, :confirmation_token,   :unique => true
    # add_index :users, :unlock_token,         :unique => true
  end

  def self.down
    drop_table :users
  end
end
