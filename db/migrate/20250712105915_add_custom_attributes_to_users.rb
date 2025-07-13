class AddCustomAttributesToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :custom_attributes, :jsonb
  end
end
