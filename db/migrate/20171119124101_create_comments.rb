class CreateComments < ActiveRecord::Migration[5.1]
  def change
    create_table :comments do |t|
      t.integer :user_id
      t.integer :issue_id
      t.text :description
      t.boolean :spam

      t.timestamps
    end
  end
end
