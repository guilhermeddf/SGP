class AddLinkgitToProject < ActiveRecord::Migration
  def change
  	add_column :projects, :linkgit, :string
  end

  def self.down
   remove_column :projects, :linkgit
 end
end
