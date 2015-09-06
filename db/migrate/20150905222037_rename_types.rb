class RenameTypes < ActiveRecord::Migration
  def change
    rename_column :activity_type_terms, :type, :term_type
    rename_column :application_terms, :type, :term_type
    rename_column :user_application_pages, :type, :app_type
  end
end
