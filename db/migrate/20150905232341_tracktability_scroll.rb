class TracktabilityScroll < ActiveRecord::Migration
  def change
    add_column :user_application_pages, :scroll_up, :integer
    add_column :user_application_pages, :scroll_down, :integer
    change_column :user_application_pages, :length, :float

  end
end
