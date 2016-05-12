class AddAppType < ActiveRecord::Migration
  def change
    add_column :applications, :app_type, :string
    add_column :application_pages, :app_type, :string
  end
end
