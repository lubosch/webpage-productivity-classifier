class AddUserToAppActType < ActiveRecord::Migration
  def change
    add_column :application_activity_types, :user_id, :integer
  end
end
