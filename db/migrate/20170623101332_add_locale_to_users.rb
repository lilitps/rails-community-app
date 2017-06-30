class AddLocaleToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :locales, :string, default: 'en'
  end
end
