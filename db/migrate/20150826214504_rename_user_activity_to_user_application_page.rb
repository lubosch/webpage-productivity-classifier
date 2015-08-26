class RenameUserActivityToUserApplicationPage < ActiveRecord::Migration
  def change
    rename_table :user_activities, :user_application_pages
    add_column :user_application_pages, :application_page_id, :integer
    add_column :user_application_pages, :user_id, :integer
  end
end
