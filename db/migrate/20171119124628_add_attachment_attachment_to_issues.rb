class AddAttachmentAttachmentToIssues < ActiveRecord::Migration[5.1]
  def self.up
    change_table :issues do |t|
      t.attachment :attachment
    end
  end

  def self.down
    remove_attachment :issues, :attachment
  end
end
