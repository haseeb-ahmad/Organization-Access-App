class AddFieldsToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :dob, :date
    add_column :users, :location, :string
  end
end
