# frozen_string_literal: true

class EnableAuthlogicFeaturesInUsers < ActiveRecord::Migration[5.1]
  def change
    change_table :users do |t|
      # Authlogic::ActsAsAuthentic::Password
      t.rename :password_digest, :crypted_password
      t.string :password_salt
      # Authlogic::ActsAsAuthentic::PersistenceToken
      t.rename :remember_digest, :persistence_token
      t.index :persistence_token, unique: true
      # Authlogic::ActsAsAuthentic::PerishableToken
      t.string    :perishable_token
      t.index     :perishable_token, unique: true
      # Authlogic::Session::MagicColumns
      t.integer   :login_count, default: 0, null: false
      t.integer   :failed_login_count, default: 0, null: false
      t.datetime  :last_request_at
      t.datetime  :current_login_at
      t.datetime  :last_login_at
      t.string    :current_login_ip
      t.string    :last_login_ip
      # Authlogic::Session::MagicStates
      t.boolean   :active, default: false
      t.boolean   :approved, default: false
      t.boolean   :confirmed, default: false
      # Remove
      t.remove :activated
      t.remove :activation_digest
      t.remove :reset_digest
      t.remove :reset_sent_at
    end

    add_index :users, :last_request_at
  end
end
