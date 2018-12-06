require_relative '20171211174801_create_translations'

class RevertTranslations < ActiveRecord::Migration[5.1]
  def change
    revert CreateTranslations
  end
end
