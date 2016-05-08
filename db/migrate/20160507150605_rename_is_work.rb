class RenameIsWork < ActiveRecord::Migration
  def change
    rename_column :application_activity_types, :is_work, :work_id
    rename_column :work_terms, :activity_type_id, :term_id

  end
end
