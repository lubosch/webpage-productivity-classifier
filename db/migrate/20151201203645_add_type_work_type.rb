class AddTypeWorkType < ActiveRecord::Migration
  def change
    add_column :application_activity_types, :is_work, :integer
  end
end
