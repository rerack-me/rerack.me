class AddAttachmentImageToGroups < ActiveRecord::Migration
  def self.up
    change_table :groups do |t|
      t.attachment :image
    end
  end

  def self.down
    drop_attached_file :groups, :image
  end
end
