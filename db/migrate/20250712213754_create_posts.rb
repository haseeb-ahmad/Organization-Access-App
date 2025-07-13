class CreatePosts < ActiveRecord::Migration[7.1]
  def change
    create_table :posts do |t|
      t.text :content
      t.references :author, null: false, foreign_key: { to_table: :users }
      t.references :space, null: false, foreign_key: true

      t.timestamps
    end
  end
end
