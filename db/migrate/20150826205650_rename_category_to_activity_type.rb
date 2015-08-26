class RenameCategoryToActivityType < ActiveRecord::Migration
  def change
    rename_table :categories, :activity_types
  end
end
