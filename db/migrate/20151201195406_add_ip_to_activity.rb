class AddIpToActivity < ActiveRecord::Migration
  def change
    add_column :user_application_pages, :ip, :string
  end
end
