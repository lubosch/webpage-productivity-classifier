class RenameDomainTermToApplicationTerm < ActiveRecord::Migration
  def change
    rename_table :domain_terms, :application_terms
  end
end
