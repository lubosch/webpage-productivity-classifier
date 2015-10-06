class AddClickrate < ActiveRecord::Migration
  def change
    add_column :user_application_pages, :key_pressed, :integer
    add_column :user_application_pages, :key_pressed_rate, :float
    add_column :user_application_pages, :scroll_rate, :float
  end
end
