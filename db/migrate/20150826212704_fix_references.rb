class FixReferences < ActiveRecord::Migration
  def change
    remove_column :applications, :domain_id, :integer

    rename_column :application_activity_types, :domain_id, :application_id
    rename_column :application_activity_types, :category_id, :activity_type_id

    rename_column :activity_type_terms, :category_id, :activity_type_id
    rename_column :activity_type_terms, :count, :tf

    rename_column :application_terms, :domain_id, :application_page_id
    remove_column :application_terms, :df, :integer

    rename_column :labels, :domain_id, :application_id

    rename_column :terms, :tf, :ttf

  end
end
