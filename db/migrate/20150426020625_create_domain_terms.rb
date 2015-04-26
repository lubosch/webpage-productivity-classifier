class CreateDomainTerms < ActiveRecord::Migration
  def change
    create_table :domain_terms do |t|
      t.references :domain
      t.references :term
      t.integer :tf
      t.integer :df
    end
  end
end
