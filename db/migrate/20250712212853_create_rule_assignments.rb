class CreateRuleAssignments < ActiveRecord::Migration[7.1]
  def change
    create_table :rule_assignments do |t|
      t.references :rule_set, null: false, foreign_key: true
      t.references :ruleable, polymorphic: true, null: false

      t.timestamps
    end
  end
end
