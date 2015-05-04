class RemoveFixedColumns < ActiveRecord::Migration
  def change
    remove_column :domains, :alter_id, :integer
    remove_column :labels, :www_id, :integer
    rename_column :labels, :nowww_id, :domain_id
  end
end
