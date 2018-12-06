class ChangeUsersDefaultLocal < ActiveRecord::Migration[5.1]
  change_column_default :users, :locale, from: 'en', to: 'de'
end
