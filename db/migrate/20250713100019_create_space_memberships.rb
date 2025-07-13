class CreateSpaceMemberships < ActiveRecord::Migration[7.1]
  def change
    create_table :space_memberships do |t|
      t.references :user, null: false, foreign_key: true
      t.references :space, null: false, foreign_key: true

      t.timestamps
    end
  end
end
