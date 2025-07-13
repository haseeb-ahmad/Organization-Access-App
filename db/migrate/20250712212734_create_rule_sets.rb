class CreateRuleSets < ActiveRecord::Migration[7.1]
  def change
    create_table :rule_sets do |t|
      t.string :name
      t.string :rule_type
      t.references :organization, null: false, foreign_key: true

      t.timestamps
    end
  end
end
