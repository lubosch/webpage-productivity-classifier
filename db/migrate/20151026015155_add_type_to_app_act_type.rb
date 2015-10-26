class AddTypeToAppActType < ActiveRecord::Migration
  def change
    add_column :application_activity_types, :based_on, :string
    add_column :application_activity_types, :application_page_id, :integer
  end
end
