class Tracktability < ActiveRecord::Migration
  def change

    add_column :user_application_pages, :length, :integer
    add_column :user_application_pages, :scroll_count, :integer
    add_column :user_application_pages, :scroll_diff, :integer
    add_column :user_application_pages, :tab_id, :integer
    add_column :user_application_pages, :type, :integer

    add_column :users, :desktop_logger, :integer

    add_column :application_pages, :url, :string
    add_column :application_pages, :static, :integer
    add_column :application_pages, :user_static, :integer

    add_column :applications, :url, :string
    add_column :applications, :static, :integer
    add_column :applications, :user_static, :integer

    add_column :application_terms, :type, :string

    add_column :activity_type_terms, :type, :string

  end
end
