# frozen_string_literal: true

class CreateTranslations < ActiveRecord::Migration[5.1]
  def change
    create_table :translations do |t|
      t.string :locale, null: false
      t.string :key, unique: true, null: false
      t.text :value, null: false
      t.text :interpolations
      t.boolean :is_proc, default: false

      t.timestamps
    end

    add_index :translations, :locale
    add_index :translations, :key
  end
end
