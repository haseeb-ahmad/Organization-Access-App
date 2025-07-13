class CreateRules < ActiveRecord::Migration[7.1]
  def change
    create_table :rules do |t|
      t.references :rule_set, null: false, foreign_key: true
      t.string :field
      t.string :operator
      t.string :value

      t.timestamps
    end
  end
end
