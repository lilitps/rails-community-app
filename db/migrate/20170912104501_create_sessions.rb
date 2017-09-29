# frozen_string_literal: true

class CreateSessions < ActiveRecord::Migration[5.1]
  def change
    create_table :user_sessions do |t|
      t.string :session_id, null: false
      t.text :data

      t.timestamps
    end

    add_index :user_sessions, :session_id
    add_index :user_sessions, :updated_at
  end
end
