class AddIndexToDomainTerm < ActiveRecord::Migration
  def change
    add_index :domain_terms, :domain_id
    add_index :labels, :domain_id
    add_index :domains, :eval_id
  end
end
