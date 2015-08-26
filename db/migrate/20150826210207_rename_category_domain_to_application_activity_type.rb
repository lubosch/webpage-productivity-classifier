class RenameCategoryDomainToApplicationActivityType < ActiveRecord::Migration
  def change
    rename_table :category_domains, :application_activity_types
  end
end
