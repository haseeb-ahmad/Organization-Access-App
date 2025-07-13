class CreateSpaces < ActiveRecord::Migration[7.1]
  def change
    create_table :spaces do |t|
      t.references :organization, null: false, foreign_key: true
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
