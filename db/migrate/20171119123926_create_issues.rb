class CreateIssues < ActiveRecord::Migration[5.1]
  def change
    create_table :issues do |t|
      t.integer :user_id
      t.integer :user_id_2
      t.string :title
      t.text :description
      t.integer :kind_id
      t.integer :priority_id
      t.integer :status_id
      t.boolean :spam

      t.timestamps
    end
  end
end
