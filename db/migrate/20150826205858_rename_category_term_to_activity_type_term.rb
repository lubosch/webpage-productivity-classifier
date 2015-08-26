class RenameCategoryTermToActivityTypeTerm < ActiveRecord::Migration
  def change
    rename_table :category_terms, :activity_type_terms
  end
end
